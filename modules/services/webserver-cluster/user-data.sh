#!/bin/bash
cat > index.html <<EOF
<h1> Hello, World </h1>
<h1> </h1>
<h1> Infrastructure as Code (IAC) is the future. Better embrace it - Girish </h1>
<h1> </h1>
<p1>Infrastructure as code is the approach to defining computing and network infrastructure</p1> 
<p1>through source code that can then be treated just like any software system</p1>
<h1> </h1>
<p1> Caution: You should put lot of thoughts into isolation, locking and state towards</p1>
<p1> infrastructure as code as it enables different trade-offs than normal coding. When you're </p1>
<p1> writing code for a typical app, most bugs are relatively minor and only break a </p1>
<p1> small part of a single app. When you're writing code that controls your </h1>
<p1> infrastructure, bugs tend to be more severe, as they can break all of your apps</p1>
<p1> - and all of your data stores and your entire network topology and just about</p1>
<p1> everything else. Therefore it is recommended including more "safety mechanisms"</p1>
<p1> when working on IAC than with typical code</h1>
<h1> </h1>

EOF
nohup busybox httpd -f -p "${server_port}" &
