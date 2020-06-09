# docker-wkd

A GNUPG WKD (Web Key Directory) generating docker image.

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

# Deploying in Kubernetes

You can use the kustomization provided as a base, but you will need to add a
few overrides.

1. You'll need to create a configmap for the keys or file
2. You'll need to patch your main website ingress to link to the wkd container on path `.well-known/openpgpkey/hu/`
