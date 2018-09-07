vcl 4.0;

backend default {
    .host = "127.0.0.1";
    .port = "8080";
}

sub vcl_recv {
    if (req.url ~ "\.(js|css|jpg|jpeg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|swf|woff)") {
        unset req.http.cookie;
        return (hash);
    }
if (req.url ~ "wp-admin|wp-login") {

return (pass);

}
  if ( req.http.cookie ~ "wordpress_logged_in|resetpass" ) {
    return( pass );
  }
set req.http.cookie = regsuball(req.http.cookie, "wp-settings-\d+=[^;]+(; )?", "");
set req.http.cookie = regsuball(req.http.cookie, "wp-settings-time-\d+=[^;]+(; )?", "");
set req.http.cookie = regsuball(req.http.cookie, "wordpress_test_cookie=[^;]+(; )?", "");

if (req.http.cookie == "") {

	unset req.http.cookie;
}

    return (hash);
}

sub vcl_pipe {
  if (req.http.upgrade) {
    set bereq.http.upgrade = req.http.upgrade;
  }
  return (pipe);
}


sub vcl_pass {
}

sub vcl_hash {
  hash_data(req.url);
  if (req.http.host) {
    hash_data(req.http.host);
  } else {
    hash_data(server.ip);
  }
#  if (req.http.Cookie) {
#    hash_data(req.http.Cookie);
#  }
}

sub vcl_hit {
  if (obj.ttl >= 0s) {
    return (deliver);
  }
 return (fetch);
}

sub vcl_miss {
    return (fetch);
}

sub vcl_backend_response {
    if (bereq.url ~ "\.(js|css|jpg|jpeg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|swf|woff)") {
        set beresp.grace = 30m;
        set beresp.ttl = 30m;
    }
    if (beresp.status == 403 || beresp.status == 404 || beresp.status >= 500) {
        set beresp.ttl = 3s;
    }
    set beresp.grace = 1h;
    set beresp.ttl = 1h;
    return (deliver);
}

sub vcl_deliver {
        if (obj.hits > 0) {
                set resp.http.X-Cache = "HIT";
        }
        else {
                set resp.http.X-Cache = "MISS";
        }
  set resp.http.Access-Control-Allow-Origin = "*";
  set resp.http.Server = "VG-WEB";
  unset resp.http.X-Powered-By;
  unset resp.http.X-Cache-Hits;
  unset resp.http.X-Varnish;
  unset resp.http.Via;
  unset resp.http.Link;
  unset resp.http.X-Generator;

  return (deliver);
}

sub vcl_purge {
  if (req.method != "PURGE") {
    set req.http.X-Purge = "Yes";
    return(restart);
  }
}

sub vcl_synth {
  unset resp.http.Server;
  unset resp.http.X-Varnish;
  if (resp.status == 720) {
    set resp.http.Location = resp.reason;
    set resp.status = 301;
    return (deliver);
  } elseif (resp.status == 721) {
    set resp.http.Location = resp.reason;
    set resp.status = 302;
    return (deliver);
  }

  return (deliver);
}

sub vcl_fini {
  return (ok);
}
