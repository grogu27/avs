all: docker_build docker_run ansible_ping ansible_setup ansible_playbook

docker_build:
	docker build -t lab3_container .

docker_run:
	docker run -d -p 2222:22 --name container1 lab3_container && docker run -d -p 2223:22 --name container2 lab3_container

ansible_ping:
	ansible -m ping all

ansible_setup:
	ansible -m setup all

ansible_playbook:
	ansible-playbook playbooks/task.yml

docker_remove:
	docker stop container1 container2 && \
	docker rm container1 container2

docker_remove_all:
	docker container prune -f
