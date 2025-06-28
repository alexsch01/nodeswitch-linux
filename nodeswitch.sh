LOCAL_SHARE="$HOME/.local/share"
mkdir -p "$LOCAL_SHARE/nodeswitch"

if [ "$1" != "" ]
then
   if [ "$2" != "" ]
   then
       if [ "$3" != "" ]
       then
           echo "Incorrect command"
       else
           if [ "$1" = "remove" ]
           then
               if [ -d "$LOCAL_SHARE/nodeswitch/$2" ]
               then
                   rm -rf "$LOCAL_SHARE/nodeswitch/$2"
               else
                   echo "Node version not installed"
               fi
           elif [ "$1" = "use" ]
           then
               if [ "$2" = "default" ]
               then
                   if [ ! -z "$nodeswitchDefaultPATH" ]
                   then
                       export PATH="$nodeswitchDefaultPATH"
                   fi
               else
                   if [ -d "$LOCAL_SHARE/nodeswitch/$2" ]
                   then
                       if [ -z "$nodeswitchDefaultPATH" ]
                       then
                           export nodeswitchDefaultPATH="$PATH"
                           export PATH="$LOCAL_SHARE/nodeswitch/$2/bin:$PATH"
                       else
                           export PATH="$LOCAL_SHARE/nodeswitch/$2/bin:$nodeswitchDefaultPATH"
                       fi
                   else
                       echo "Node version not installed"
                   fi
               fi
           elif [ "$1" = "add" ]
           then
               if [ ! -d "$LOCAL_SHARE/nodeswitch/$2" ]
               then
                   curl -f https://nodejs.org/download/release/v$2/ &>/dev/null
                   if [ $? -eq 0 ]
                   then
                       curl -s -o "$LOCAL_SHARE/nodeswitch/$2.xz" https://nodejs.org/download/release/v$2/node-v$2-linux-x64.tar.xz > /dev/null

                       if [ $? -ne 0 ]
                       then
                           rm "$LOCAL_SHARE/nodeswitch/$2.xz"
                           echo "Node version not created"
                           exit
                       fi

                       tar -xf "$LOCAL_SHARE/nodeswitch/$2.xz" -C "$LOCAL_SHARE/nodeswitch" > /dev/null

                       if [ $? -ne 0 ]
                       then
                           rm "$LOCAL_SHARE/nodeswitch/$2.xz"
                           rm -rf "$LOCAL_SHARE/nodeswitch/node-v$2-linux-x64"
                           echo "Node version not created"
                           exit
                       fi

                       rm "$LOCAL_SHARE/nodeswitch/$2.xz"
                       mv "$LOCAL_SHARE/nodeswitch/node-v$2-linux-x64" "$LOCAL_SHARE/nodeswitch/$2" > /dev/null
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
       if [ "$1" = "list" ]
       then
           dir -1 "$LOCAL_SHARE/nodeswitch"
       elif [ "$1" = "path" ]
       then
           echo "$LOCAL_SHARE/nodeswitch"
       else
           echo "Incorrect command"
       fi
   fi
else
   echo "Incorrect command"
fi
