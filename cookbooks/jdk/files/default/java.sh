if ! echo $PATH | /bin/grep -q java
then
    export PATH=/opt/java/bin:$PATH
fi

export JAVA_HOME=/opt/java

