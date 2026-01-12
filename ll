Name:           csi-secrets-store-provider-aws
Namespace:      kube-system
Selector:       app=csi-secrets-store-provider-aws
Node-Selector:  kubernetes.io/os=linux
Labels:         app=csi-secrets-store-provider-aws
Annotations:    deprecated.daemonset.template.generation: 1
Desired Number of Nodes Scheduled: 2
Current Number of Nodes Scheduled: 2
Number of Nodes Scheduled with Up-to-date Pods: 2
Number of Nodes Scheduled with Available Pods: 2
Number of Nodes Misscheduled: 0
Pods Status:  2 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           app=csi-secrets-store-provider-aws
  Service Account:  csi-secrets-store-provider-aws
  Containers:
   provider-aws-installer:
    Image:      public.ecr.aws/aws-secrets-manager/secrets-store-csi-driver-provider-aws:2.1.0
    Port:       <none>
    Host Port:  <none>
    Args:
      --provider-volume=/var/run/secrets-store-csi-providers
    Limits:
      cpu:     50m
      memory:  100Mi
    Requests:
      cpu:        50m
      memory:     100Mi
    Environment:  <none>
    Mounts:
      /var/lib/kubelet/pods from mountpoint-dir (rw)
      /var/run/secrets-store-csi-providers from providervol (rw)
  Volumes:
   providervol:
    Type:          HostPath (bare host directory volume)
    Path:          /var/run/secrets-store-csi-providers
    HostPathType:  
   mountpoint-dir:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/kubelet/pods
    HostPathType:  DirectoryOrCreate
  Node-Selectors:  kubernetes.io/os=linux
  Tolerations:     <none>
Events:
  Type    Reason              Age   From                  Message
  ----    ------              ----  ----                  -------
  Normal  SuccessfulCreate    60m   daemonset-controller  Created pod: csi-secrets-store-provider-aws-cjf9s
  Normal  SuccessfulCreate    60m   daemonset-controller  Created pod: csi-secrets-store-provider-aws-hx4qq
  Normal  SucceededDaemonPod  41m   daemonset-controller  Found succeeded daemon pod kube-system/csi-secrets-store-provider-aws-cjf9s on node ip-192-168-40-243.eu-central-1.compute.internal, will try to delete it
  Normal  SuccessfulDelete    41m   daemonset-controller  Deleted pod: csi-secrets-store-provider-aws-cjf9s
  Normal  SucceededDaemonPod  41m   daemonset-controller  Found succeeded daemon pod kube-system/csi-secrets-store-provider-aws-hx4qq on node ip-192-168-1-128.eu-central-1.compute.internal, will try to delete it
  Normal  SuccessfulDelete    41m   daemonset-controller  Deleted pod: csi-secrets-store-provider-aws-hx4qq
  Normal  SuccessfulCreate    32m   daemonset-controller  Created pod: csi-secrets-store-provider-aws-jr82b
  Normal  SuccessfulCreate    32m   daemonset-controller  Created pod: csi-secrets-store-provider-aws-n75qk

Name:           csi-secrets-store-secrets-store-csi-driver
Namespace:      kube-system
Selector:       app=secrets-store-csi-driver
Node-Selector:  kubernetes.io/os=linux
Labels:         app=secrets-store-csi-driver
                app.kubernetes.io/instance=csi-secrets-store
                app.kubernetes.io/managed-by=Helm
                app.kubernetes.io/name=secrets-store-csi-driver
                app.kubernetes.io/version=1.5.5
                helm.sh/chart=secrets-store-csi-driver-1.5.5
Annotations:    deprecated.daemonset.template.generation: 1
                meta.helm.sh/release-name: csi-secrets-store
                meta.helm.sh/release-namespace: kube-system
Desired Number of Nodes Scheduled: 2
Current Number of Nodes Scheduled: 2
Number of Nodes Scheduled with Up-to-date Pods: 2
Number of Nodes Scheduled with Available Pods: 2
Number of Nodes Misscheduled: 0
Pods Status:  2 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           app=secrets-store-csi-driver
                    app.kubernetes.io/instance=csi-secrets-store
                    app.kubernetes.io/managed-by=Helm
                    app.kubernetes.io/name=secrets-store-csi-driver
                    app.kubernetes.io/version=1.5.5
                    helm.sh/chart=secrets-store-csi-driver-1.5.5
  Annotations:      kubectl.kubernetes.io/default-container: secrets-store
  Service Account:  secrets-store-csi-driver
  Containers:
   node-driver-registrar:
    Image:      registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.13.0
    Port:       <none>
    Host Port:  <none>
    Args:
      --v=5
      --csi-address=/csi/csi.sock
      --kubelet-registration-path=/var/lib/kubelet/plugins/csi-secrets-store/csi.sock
    Limits:
      cpu:     100m
      memory:  100Mi
    Requests:
      cpu:        10m
      memory:     20Mi
    Environment:  <none>
    Mounts:
      /csi from plugin-dir (rw)
      /registration from registration-dir (rw)
   secrets-store:
    Image:       registry.k8s.io/csi-secrets-store/driver:v1.5.5
    Ports:       9808/TCP (healthz), 8095/TCP (metrics)
    Host Ports:  0/TCP (healthz), 0/TCP (metrics)
    Args:
      --endpoint=$(CSI_ENDPOINT)
      --nodeid=$(KUBE_NODE_NAME)
      --provider-volume=/var/run/secrets-store-csi-providers
      --additional-provider-volume-paths=/etc/kubernetes/secrets-store-csi-providers
      --metrics-addr=:8095
      --provider-health-check-interval=2m
      --max-call-recv-msg-size=4194304
    Limits:
      cpu:     200m
      memory:  200Mi
    Requests:
      cpu:     50m
      memory:  100Mi
    Liveness:  http-get http://:healthz/healthz delay=30s timeout=10s period=15s #success=1 #failure=5
    Environment:
      CSI_ENDPOINT:    unix:///csi/csi.sock
      KUBE_NODE_NAME:   (v1:spec.nodeName)
    Mounts:
      /csi from plugin-dir (rw)
      /etc/kubernetes/secrets-store-csi-providers from providers-dir-0 (rw)
      /var/lib/kubelet/pods from mountpoint-dir (rw)
      /var/run/secrets-store-csi-providers from providers-dir (rw)
   liveness-probe:
    Image:      registry.k8s.io/sig-storage/livenessprobe:v2.15.0
    Port:       <none>
    Host Port:  <none>
    Args:
      --csi-address=/csi/csi.sock
      --probe-timeout=3s
      --http-endpoint=0.0.0.0:9808
      -v=2
    Limits:
      cpu:     100m
      memory:  100Mi
    Requests:
      cpu:        10m
      memory:     20Mi
    Environment:  <none>
    Mounts:
      /csi from plugin-dir (rw)
  Volumes:
   mountpoint-dir:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/kubelet/pods
    HostPathType:  DirectoryOrCreate
   registration-dir:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/kubelet/plugins_registry/
    HostPathType:  Directory
   plugin-dir:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/kubelet/plugins/csi-secrets-store/
    HostPathType:  DirectoryOrCreate
   providers-dir:
    Type:          HostPath (bare host directory volume)
    Path:          /var/run/secrets-store-csi-providers
    HostPathType:  DirectoryOrCreate
   providers-dir-0:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/kubernetes/secrets-store-csi-providers
    HostPathType:  DirectoryOrCreate
  Node-Selectors:  kubernetes.io/os=linux
  Tolerations:     op=Exists
Events:
  Type     Reason            Age   From                  Message
  ----     ------            ----  ----                  -------
  Normal   SuccessfulCreate  60m   daemonset-controller  Created pod: csi-secrets-store-secrets-store-csi-driver-nbb54
  Normal   SuccessfulCreate  60m   daemonset-controller  Created pod: csi-secrets-store-secrets-store-csi-driver-w6jz8
  Warning  FailedDaemonPod   41m   daemonset-controller  Found failed daemon pod kube-system/csi-secrets-store-secrets-store-csi-driver-nbb54 on node ip-192-168-40-243.eu-central-1.compute.internal, will try to kill it
  Normal   SuccessfulDelete  41m   daemonset-controller  Deleted pod: csi-secrets-store-secrets-store-csi-driver-nbb54
  Normal   SuccessfulCreate  41m   daemonset-controller  Created pod: csi-secrets-store-secrets-store-csi-driver-qtfqv
  Warning  FailedDaemonPod   41m   daemonset-controller  Found failed daemon pod kube-system/csi-secrets-store-secrets-store-csi-driver-qtfqv on node ip-192-168-40-243.eu-central-1.compute.internal, will try to kill it
  Normal   SuccessfulDelete  41m   daemonset-controller  Deleted pod: csi-secrets-store-secrets-store-csi-driver-qtfqv
  Normal   SuccessfulCreate  41m   daemonset-controller  Created pod: csi-secrets-store-secrets-store-csi-driver-5qw5t
  Warning  FailedDaemonPod   41m   daemonset-controller  Found failed daemon pod kube-system/csi-secrets-store-secrets-store-csi-driver-5qw5t on node ip-192-168-40-243.eu-central-1.compute.internal, will try to kill it
  Normal   SuccessfulDelete  41m   daemonset-controller  Deleted pod: csi-secrets-store-secrets-store-csi-driver-5qw5t
  Normal   SuccessfulCreate  41m   daemonset-controller  Created pod: csi-secrets-store-secrets-store-csi-driver-l7p4m
  Warning  FailedDaemonPod   41m   daemonset-controller  Found failed daemon pod kube-system/csi-secrets-store-secrets-store-csi-driver-w6jz8 on node ip-192-168-1-128.eu-central-1.compute.internal, will try to kill it
  Normal   SuccessfulDelete  41m   daemonset-controller  Deleted pod: csi-secrets-store-secrets-store-csi-driver-w6jz8
  Normal   SuccessfulCreate  41m   daemonset-controller  Created pod: csi-secrets-store-secrets-store-csi-driver-6d2gt
  Warning  FailedDaemonPod   41m   daemonset-controller  Found failed daemon pod kube-system/csi-secrets-store-secrets-store-csi-driver-6d2gt on node ip-192-168-1-128.eu-central-1.compute.internal, will try to kill it
  Normal   SuccessfulDelete  41m   daemonset-controller  Deleted pod: csi-secrets-store-secrets-store-csi-driver-6d2gt
  Normal   SuccessfulCreate  41m   daemonset-controller  Created pod: csi-secrets-store-secrets-store-csi-driver-ncnrn
  Warning  FailedDaemonPod   41m   daemonset-controller  Found failed daemon pod kube-system/csi-secrets-store-secrets-store-csi-driver-ncnrn on node ip-192-168-1-128.eu-central-1.compute.internal, will try to kill it
  Normal   SuccessfulDelete  41m   daemonset-controller  Deleted pod: csi-secrets-store-secrets-store-csi-driver-ncnrn
  Normal   SuccessfulCreate  41m   daemonset-controller  Created pod: csi-secrets-store-secrets-store-csi-driver-8qx6q
  Warning  FailedDaemonPod   41m   daemonset-controller  Found failed daemon pod kube-system/csi-secrets-store-secrets-store-csi-driver-8qx6q on node ip-192-168-1-128.eu-central-1.compute.internal, will try to kill it
  Normal   SuccessfulDelete  41m   daemonset-controller  Deleted pod: csi-secrets-store-secrets-store-csi-driver-8qx6q
  Normal   SuccessfulCreate  41m   daemonset-controller  Created pod: csi-secrets-store-secrets-store-csi-driver-d94br
  Normal   SuccessfulCreate  32m   daemonset-controller  Created pod: csi-secrets-store-secrets-store-csi-driver-5plzg
  Normal   SuccessfulCreate  32m   daemonset-controller  Created pod: csi-secrets-store-secrets-store-csi-driver-hll4s

