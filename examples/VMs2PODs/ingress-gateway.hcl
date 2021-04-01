Kind = "ingress-gateway"
Name = "ingress-acme"

Listeners = [
 {
   Port = 8080
   Protocol = "tcp"
   Services = [
     {
       Name = "nginx"
     }
   ]
 }
]
