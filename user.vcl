# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.1 format.
vcl 4.1;

backend default {
    .host = "${VARNISH_BACKEND_HOST}";
    .port = "${VARNISH_BACKEND_PORT}";
    .probe = {
        .url = "${VARNISH_BACKEND_PROBE_URL}";
        .timeout = 1s;
        .interval = 60s;
        .window = 10;
        .threshold = 8;
    }
}

sub vcl_recv {
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.

    set req.http.x-host = req.http.host;
    set req.http.x-url = req.url;
    set req.http.x-origin = req.http.origin;

    set req.http.host = "${VARNISH_BACKEND_HOST}";
    set req.http.origin = "${VARNISH_BACKEND_HOST}";

    if (req.method == "POST") {
        return (pass);
    }
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.
    set beresp.ttl = 5m;
    set beresp.grace = 1h;
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
}