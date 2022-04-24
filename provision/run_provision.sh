if [ "$1" = "cicd" ]; then
	docker run -dti --name gitea --restart always -v gitea:/data -p 3000:3000 -p 2222:22 gitea/gitea:latest > /dev/null 2>&1 && echo "[OK] GITEA container started"
fi