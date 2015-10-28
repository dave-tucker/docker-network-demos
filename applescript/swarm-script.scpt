tell application iTerm
    activate
    tell current session of current terminal
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
        write text "echo \"Swarm can show you all of your networks\" | figlet | lolcat"
        delay 5
        write text "docker network ls"
        delay 5
        write text "echo \"Let's create a new one\" | figlet | lolcat"
        delay 5
        write text "docker network create -d overlay myapp"
        delay 5
        write text "echo \"OK! Here it is in Swarm\" | figlet | lolcat"
        delay 5
        write text "docker network ls"
        delay 5
        write text "docker network inspect myapp"
        delay 5
        write text "echo \"Let's create two containers\" | figlet | lolcat"
        delay 5
        write text "echo \"Nginx on swl-demo0\" | figlet | lolcat"
        delay 5
        write text "echo \"And a client on swl-demo1\" | figlet | lolcat"
        delay 5
        write text "docker run -itd --name=web --net=myapp --env=\"constraint:node==swl-demo0\" nginx"
        delay 5
        write text "docker run -it --rm --net=myapp --env=\"constraint:node==swl-demo1\" busybox wget -O- http://web"
        delay 5
        write text "echo \"That's how easy it is for container to talk across hosts\" | figlet | lolcat
        delay 5
    end tell
end tell
