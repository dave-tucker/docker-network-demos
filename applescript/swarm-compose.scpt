tell application iTerm
    tell current session of first window
        write text "echo \"First, set up your environment\" | figlet | lolcat"
        delay 5
        write text "echo \"The instructions are in the blog post\" | figlet | lolcat"
        delay 5
        write text "echo \"Here's mine...\" | figlet | lolcat"
        delay 5
        write text "docker-machine ls"
        delay 5
        write text "echo \"Now, let's talk to swarm\" | figlet | lolcat"
        delay 5
        write text "eval $(docker-machine env --swarm swl-demo0)"
        delay 5
        write text "echo \"Here is our docker-compose.yml file\" | figlet | lolcat"
        delay 5
        write text "cat docker-compose.yml"
        delay 5
        write text "echo \"Let's deploy this to our Swarm\" | figlet | lolcat"
        delay 5
        write text "docker compose --x-networking --x-network-driver overlay -d"
        delay 30
        write text "echo \"OK! Compose created a network for us\" | figlet | lolcat"
        delay 5
        write text "docker network ls"
        delay 5
        write text "echo \"And spread our containers across our hosts\" | figlet | lolcat"
        delay 5
        write text "docker ps -a"
        delay 5
        write text "And our application is working!"
        delay 5
        write text "wget -qO- http://$(docker-machine ip swl-demo0)"
        delay 5
        write text "wget -qO- http://$(docker-machine ip swl-demo0)"
        delay 5
        write text "wget -qO- http://$(docker-machine ip swl-demo0)"
        delay 5
        write text "echo \"Simples!\" | figlet | lolcat
        delay 5
        write text "
        delay 5
    end tell
end tell
