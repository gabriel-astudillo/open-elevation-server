### Change script permissions

```
cd open.elevation.server
chmod +x make-srtm-data.sh openElevationServer.py
```

### Installing Dependencies

In order for Open-Elevation for DEMPS simulator to work, you need `GDAL` and `libspatialindex`. For the full process to work you also need a version of `unar`. 

The setup for `gdal` depends on the distro and may even change among distro versions, thus being outside the scope of this documentation. Please follow the documentation found in [GDAL's homepage](http://www.gdal.org/).

The following are instructions for Ubuntu/Debian compatible distros, and similar ones might apply to your particular setup. Again, make sure you also install GDAL. 

```
apt-get install -y libspatialindex-dev unar gdal-bin
sudo -H pip3 install lazy bottle rtree gunicorn
```

If all goes well, you now have the required dependencies to run Open-Elevation.

### Prerequisites: Getting the dataset

This Open-Elevation server doesn't come with any data of its own, but it offers a set of scripts to get the whole [SRTM 250m dataset](https://srtm.csi.cgiar.org/srtm-250-resolution/).

#### Whole World

If you wish to host the whole world, just run

```
./make-srtm-data.sh
```

**Assuming you have `wget` and `unar`installed**, the above command should have downloaded the entire SRTM dataset and split it into multiple smaller files in a `srtm_data` directory. **Be aware that this directory may be over 20 GB in size after the process is completed!**


### Running the server in foreground

Now that you've got your data, you're ready to run Open-Elevation for DEMPS simulator. Simply run

```
python3 openElevationServer.py
```

The config file is `openElevationServer.config`.

### Running the server as a service or daemon

A makefile is provided to help to install the service file and start/stop the service.

```
make installservice
make start
```

### Running the Server with SSL

Before starting, the server checks for an SSL certificate and key files at the `certs/`subdirectory (this can be changed in the config file).
If found, the server boots using SSL/HTTPS (and only that). File names should be `/code/certs/cert.crt` and `/code/certs/cert.key`.

