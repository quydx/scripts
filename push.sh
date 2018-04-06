git config --global credential.helper 'cache --timeout 7200'
git status
git add .
if [[ ! $1 ]];then
	set -- "update code"
fi
git commit -a -m "$1"
git push origin master