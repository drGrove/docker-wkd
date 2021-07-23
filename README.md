# docker-wkd

A OpenPGP WKD (Web Key Directory) generating docker image.

## Usage

| ENV VAR          | Required   | Defaults         | Description                                                           |
| ---------------- | :--------: | :-----:          | -------------                                                         |
| MAIL_DOMAIN      | *          |                  | The domain you'd like to generate key files for. (ex. drgrovellc.com) |
| DATA_FILE_PATH   |            | `/data/keys.txt` | The path to the datafile                                              |
| HU_FOLDER        |            | `/data/`         | The folder you'd like to generate the wkd in                          |

```bash
# Make your folders
mkdir data hu .gnupg

# Make your keys.txt file

# This will pull the key from a keyserver and then generate the correct file for WKD.
# If you'd like to provide your own keys use the folder option

echo "C92FE5A3FBD58DD3EC5AA26BB10116B8193F2DBD # Danny Grove" > data/keys.txt

# Using folder.
gpg --export --armour <FINGERPRINT> > data/<email-username>.asc

docker run --rm \
  -v $PWD/data:/data/ -v $PWD/hu:/root/hu -v $PWD/.gnupg:/root/.gnupg \
  -e MAIL_DOMAIN=drgrovellc.com
  drgrove/wkd
```

## Deploying in Kubernetes

You can use the kustomization provided as a base, but you will need to add a
few overrides.

### Adding a Key

To add a key to WKD you simpely create a configmap for that key with the label `wkd: enroll`. The example below with use a configMapGenerator

```yaml
# kustomization.yaml
...
configMapGenerator:
  - name: mykey
    options:
      labels:
        wkd: 'enroll'
      files:
      - pgp/mykey.asc
```

Assumed folder structure of above example:

```yaml
kustomize
|- kustomization.yaml
|- pgp/
   |- mykey.asc
```

### Patching your ingress

The example below is using nginx-ingress-controller. This is binding /.well-known/openpgp to the `wkd` service.

```yaml
# ingess.yaml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mywebsite
  labels:
    app.kubernetes.io/name: mywebsite
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    kubernetes.io/ingress.class: nginx
spec:
  tls:
    - hosts:
      - mywebsite.com
      secretName: mywebsite-tls
  rules:
    - host: mywebsite.com
      http:
        paths:
          - path: /.well-known/openpgpkey/
            backend:
              service:
                name: wkd
                port: 80
```

### Cluster Install

If you'd like to be able in aggregate PGP keys that have been installed in other namespaces you can do so by adding cluster-rbac to your install

```yaml
# kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: wkd
resources:
  - github.com/drGrove/docker-wkd/kustomize/direct
  - github.com/drGrove/docker-wkd/kustomize/cluster-rbac
```
