nodeswitchLocalShare="$HOME/.local/share"
nodeswitchUnameM=$(uname -m)

if [ "$nodeswitchUnameM" = "x86_64" ]; then
    nodeswitchArch=x64
elif [ "$nodeswitchUnameM" = "aarch64" ]; then
    nodeswitchArch=arm64
else
    echo "ARCH not supported"
    return
fi

if [ "$1" != "" ]; then
    if [ "$2" != "" ]; then
        if [ "$3" != "" ]; then
            echo "Incorrect command"
        else
            if [ "$1" = "remove" ]; then
                if [ -d "$nodeswitchLocalShare/nodeswitch/$2" ]; then
                    rm -rf "$nodeswitchLocalShare/nodeswitch/$2"
                else
                    echo "Node version not installed"
                fi
            elif [ "$1" = "use" ]; then
                if [ "$2" = "default" ]; then
                    if [ ! -z "$nodeswitchDefaultPATH" ]; then
                        export PATH="$nodeswitchDefaultPATH"
                    fi
                else
                    if [ -d "$nodeswitchLocalShare/nodeswitch/$2" ]; then
                        if [ -z "$nodeswitchDefaultPATH" ]; then
                            export nodeswitchDefaultPATH="$PATH"
                            export PATH="$nodeswitchLocalShare/nodeswitch/$2/bin:$PATH"
                        else
                            export PATH="$nodeswitchLocalShare/nodeswitch/$2/bin:$nodeswitchDefaultPATH"
                        fi
                    else
                        echo "Node version not installed"
                    fi
                fi
            elif [ "$1" = "add" ]; then
                if [ ! -d "$nodeswitchLocalShare/nodeswitch/$2" ]; then
                    curl -f https://nodejs.org/download/release/v$2/ &>/dev/null
                    if [ $? -eq 0 ]; then
                        curl -s -o "$nodeswitchLocalShare/nodeswitch/$2.xz" https://nodejs.org/download/release/v$2/node-v$2-linux-$nodeswitchArch.tar.xz > /dev/null

                        if [ $? -ne 0 ]; then
                            rm "$nodeswitchLocalShare/nodeswitch/$2.xz"
                            echo "Node version not created"
                            return
                        fi

                        tar -xf "$nodeswitchLocalShare/nodeswitch/$2.xz" -C "$nodeswitchLocalShare/nodeswitch" > /dev/null

                        if [ $? -ne 0 ]; then
                            rm "$nodeswitchLocalShare/nodeswitch/$2.xz"
                            rm -rf "$nodeswitchLocalShare/nodeswitch/node-v$2-linux-$nodeswitchArch"
                            echo "Node version not created"
                            return
                        fi

                        rm "$nodeswitchLocalShare/nodeswitch/$2.xz"
                        mv "$nodeswitchLocalShare/nodeswitch/node-v$2-linux-$nodeswitchArch" "$nodeswitchLocalShare/nodeswitch/$2" > /dev/null
                    else
                        echo "Node version not found"
                    fi
                else
                    echo "Node version already added"
                fi
            else
                echo "Incorrect command"
            fi
        fi
    else
        if [ "$1" = "list" ]; then
            dir -1 "$nodeswitchLocalShare/nodeswitch"
        elif [ "$1" = "path" ]; then
            echo "$nodeswitchLocalShare/nodeswitch"
        else
            echo "Incorrect command"
        fi
    fi
else
    echo "Incorrect command"
fi
