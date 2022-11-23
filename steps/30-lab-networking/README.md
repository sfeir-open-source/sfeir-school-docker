# Lab 3 - Network

## Expose port

### Tips

- Port must be higher than 1024

### Expose port

1. Pull `couchdb:2.1`
2. Run couchdb, name it `couchedb1` and expose the port `5984` (detached)
3. Check the couchedb version on `http://localhost:5984`
4. Run temporary busybox container
5. Call `localhost:5984` with `wget` from busybox container
   1. What happened ?
   2. Why ?
6. Call `couchdb1:5984` with `wget` from busybox container
   1. What happened ?
   2. Why ?
7. Create a new network named `busyboxtocouchdb`
8. Connect `couchdb1` to the network with `docker network connect ...`
9. Re-run busybox connected to the same network
10. Call `couchdb1:5984` with `wget` from busybox container