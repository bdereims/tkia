FROM alpine
COPY octant /octant
WORKDIR /.
RUN mkdir -p /.kube
COPY config /.kube/config
EXPOSE 80
CMD OCTANT_LISTENER_ADDR=0.0.0.0:80 ./octant --kubeconfig ./.kube/config --disable-open-browser
