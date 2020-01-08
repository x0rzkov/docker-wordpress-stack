vcl 4.0;
import std;

backend default {
  .host = "nginx";
  .port = "80";
}

acl purge { 
	# Only localhost can purge my cache
	"127.0.0.1";
	"localhost";
}

sub vcl_recv {

       /* Set client ip to headers */

       if (req.restarts == 0) {

               if (req.http.x-forwarded-for) {

                       set req.http.X-Forwarded-For =

                       req.http.X-Forwarded-For + ", " + client.ip;

               } else {

                       set req.http.X-Forwarded-For = client.ip;

               }

       }

       /* Allow PURGE of the cache only from localhost */

       if (req.method == "PURGE") {

               if ( !client.ip ~ purge) {

                       return (synth( 405, "Not allowed."));

               }

               return (purge);

       }

       /* Any other method/type, forward without even looking of the content */

       if (req.method != "GET" &&

               req.method != "HEAD" &&

               req.method != "PUT" &&

               req.method != "POST" &&

               req.method != "TRACE" &&

               req.method != "OPTIONS" &&

               req.method != "DELETE") {

                       return (pipe);

       }

       /* Don't cache other than GET and HEAD */

       if (req.method != "GET" && req.method != "HEAD") {
       		std.syslog(180, "BAN " + client.ip + " METHOD " +req.method);
               return (pass);

       }

       /* Don't cache cookies for admin site */

       if ((req.url ~ "wp-(login|admin)") &&

               (req.url ~ "&preview=true" ) ) {

               return (pass);

       }

       /* Pass authenticated request without caching*/

       if (req.http.Authorization || req.http.Cookie) {

               return (pass);

       }

       /* Finally see if content is in cache, if not then add it */

       return (hash);

}

/* Deliver cached content */

sub vcl_hit {

   return (deliver);

}

/* If content is not in cache, fetch from backend */

sub vcl_miss {

   return (fetch);

}

 

sub vcl_backend_response {

       /* Vary the content based on different devices. */

   if (bereq.http.X-UA-Device) {

       if (!beresp.http.Vary) { # no Vary at all

           set beresp.http.Vary = "X-UA-Device";

       } elseif (beresp.http.Vary !~ "X-UA-Device") { # add to existing Vary

           set beresp.http.Vary = beresp.http.Vary + ", X-UA-Device";

       }

   }

   /* Again, not cache admin, otherwise time to live for the cache content is 96 hours */

   if (!(bereq.url ~ "wp-(login|admin)")) {

       unset beresp.http.set-cookie;

       set beresp.ttl = 96h;

   }

   /* if content is not cacheable, pass them on for the next 2 minutes (uncacheable = true) */

   if (beresp.ttl <= 0s ||

       beresp.http.Set-Cookie ||

       beresp.http.Vary == "*") {

           set beresp.ttl = 120 s;

                       set beresp.uncacheable = true;

   }

   return (deliver);

}

/* Deviler the content, set device type cookies */

sub vcl_deliver {

   if ((req.http.X-UA-Device) && (resp.http.Vary)) {

       set resp.http.Vary = regsub(resp.http.Vary, "X-UA-Device", "User-Agent");

   }

}

/* If there's device type header, make separate cache to it */

sub vcl_hash {

   if (req.http.X-UA-Device) {

       hash_data(req.http.X-UA-Device);

   }

}