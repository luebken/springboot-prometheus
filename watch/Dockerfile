FROM ubuntu:20.04
RUN apt-get update; apt-get install -y curl
ADD ./watch.sh /home
RUN chmod +x /home/watch.sh
ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
CMD ["/home/watch.sh"]