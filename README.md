# docker-davfs-webdisk
This is a docker container to keep a webdav folder in sync using unison.
I created this container to keep an offline copy of my webdav folder of [Stack](https://www.transip.nl/stack/) on my Ubuntu home server.
It works both ways. If online a file is added it will be downloaded and if a file is added to the offline folder it will be uploaded automatically.

## How to use the container
To be able to use the davfs we need a fuse device. Make sure the container is started with the following **mandatory** settings:
- `privileged` mode
- `/dev/fuse` device
- Variables: `WEBDRIVE_USER`, `WEBDRIVE_PASSWORD` and `WEBDRIVE_URL`
A shared host volume can be used for the offline webdav folder. By default all files that are created in the share are for user root with access rights `755`. This can be changed using the **optional** variables:
- `SYNC_USERID` and `SYNC_GROUPID`
- `SYNC_ACCESS_DIR` and `SYNC_ACCESS_FILE`
You can also pick any o the provided unison profiles, but at least one is mandatory:
- `unison_profile_bidirectional.prf` the most common use case - sync in both directions (newest)
- `unison_profile_download-only.prf` to perform a backup of the webdrive (overwrite local changes)
- `unison_profile_upload-only.prf` to perform a backup to the webdrive (overwrite remote changes)
or you copy one of them and adapt them according to your needs.

```bash
docker run -d \
-e WEBDRIVE_USER=<username> \
-e WEBDRIVE_PASSWORD=<password> \
-e WEBDRIVE_URL=https://foo/bar/webdav/ \
-e SYNC_USERID=1001 \
-e SYNC_GROUPID=1001 \
-e SYNC_ACCESS_DIR=755 \
-e SYNC_ACCESS_FILE=755 \
-v <host/path/to/offline/folder>:/mnt/local \
-v ./unison_profile_bidirectional.prf:/root/.unison/default.prf \
--privileged \
--device /dev/fuse \
--log-opt max-size=10m \
davfs-webdisk
```

- if no `SYNC_USERID` is given `0` or root will be used as default user for the created files in the shared volume.

The configuration of unison can be changed by override it using `-v <host/path/to/unision/profile.prf>:/root/.unison/default.prf`  
For more information about unison profiles see the [manual](https://raw.githubusercontent.com/bcpierce00/unison/documentation/unison-manual.pdf, chapter 6.5 Profiles.
