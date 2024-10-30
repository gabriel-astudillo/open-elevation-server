SERVICE_EXE  = openElevationServer.py
SERVICE_FILE = openElevationServer.service

SYSTEMD_SCRIPTS_DIR = /usr/lib/systemd/system
DAEMON_RELOAD       = systemctl daemon-reload


installservice:
	@echo Installing service file $(SERVICE_FILE) in $(SYSTEMD_SCRIPTS_DIR)
	@sudo sudo cp $(SERVICE_FILE) $(SYSTEMD_SCRIPTS_DIR)
	@echo Reload systemd configuration
	@sudo $(DAEMON_RELOAD)
	

install:
	@echo Stopping service
	@sudo systemctl stop $(SERVICE_FILE)
	@sudo systemctl start $(SERVICE_FILE)
	@echo "===== commands for controlling service ====="
	@echo "sudo systemctl {start|stop|reload} $(SERVICE_FILE)"
	@echo "===== command for enable service in boot secuence ====="
	@echo "sudo systemctl enable $(SERVICE_FILE)"
	@echo

status:
	@sudo systemctl status $(SERVICE_FILE)

start:
	@sudo systemctl start $(SERVICE_FILE)

stop:
	@sudo systemctl stop $(SERVICE_FILE)

restart:
	@sudo systemctl restart $(SERVICE_FILE)

reload:
	@sudo systemctl reload $(SERVICE_FILE)

	
