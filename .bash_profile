  ~ cat .bash_profile
  export MAVEN_ORTS="Xms1024m -Xmx4096m -XX:PermSize-1024m"
  export DOCKER_HOST=tcp://192.168.59.103:2376
  export DOCKER_CERT_PATH=/Users/bill/.boot2docker/certs/boot2docker-vm
  export DOCKER_TLS_VERIFY=1
  ~

  if [[ -n $BASHPROFILE ]]; then
    source $BASHPROFILE
  fi

  BASHPROFILE="$HOME/.bash_profile"



  export qiniu_access_key=M1tcQFbMB3hHHShdT4dHqBEdWBJhKeGgtSs9Hw9t
  export qiniu_secret_key=xPNIqwHKGYSHL_2su77-oM0Me0TrmMnc8P7AV5M1
  export qiniu_bucket=jd-store-demo
  export qiniu_bucket_domain=oqex30cqv.bkt.clouddn.com
