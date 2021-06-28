(function() {
  'use strict';

  const hostname    = require("os").hostname(),
        dbname      = 'sfeirschool',
        port        = 9000,
		exitHook    = require('async-exit-hook'),
        nano        = require('nano'),
        http        = require('http');

  var couchdbHost = 'http://couchdb:5984/';
  if( process.argv.length == 3 ) {
    couchdbHost = 'http://' + process.argv[2] + ':5984/';
  }
  console.log( 'Using ' + couchdbHost + ' as couchdb url' );

  // create database
  createDb();

  function startServer() {
    /* START SERVER */

    http.createServer( handleRequest ).listen(port);
    console.log('Server BACK running at http://' + hostname + ':' + port + '/');

    /* POST START INIT */

    // create container document with id=hostname and status "started"
    register( 'back', hostname );

    exitHook( callback => {
      // get and update container document with status = "stopped"
      unregister( 'back', hostname, callback );
    });
  };

  /* CREATE DB FUNCTION */

  function createDb(){
    var tmpNano = nano({
      url: couchdbHost,
      requestDefaults: { "timeout" : "5000" } // in milliseconds
    });

    tmpNano.db.get( dbname, function( err, body ) {
      if( err ) {
        tmpNano.db.create( dbname, function(err, body) {
          if( err ) {
            console.error( err );
            setTimeout( createDb, 1000);
          } else {
            console.log( 'Database created : ' + couchdbHost + dbname );
            createView();
          }
        });
      } else {
        console.log( `Database ${dbname} exists` );
        createView();
      }
    });
  }

  /* CREATE VIEW FUNCTION */
  function createView() {
    connect().insert(
      {
        "_id": "_design/calls",
        "views": {
          "type": {
            "map": "function (doc) {\n  if(doc.type === 'call') {\n        emit(doc.front + '/' + doc.back, 1);\n    }\n}",
            "reduce": "_count"
          }
        },
        "language": "javascript"
      },
      function( err ) {
        if( err ) {
          console.error( err );
          //throw err;
        } else {
          console.log( 'View created' );
        }
        startServer();
      });
  }

  /* REQUEST HANDLE FUNCTION */

  function handleRequest(request, response) {

    const remote = request.url.split('/')[2];
    console.log( 'Back: got request '+ request.url );

    if( request.url.startsWith('/register/') ) {
        register( 'front', remote );
        response.writeHead( 200 );
        response.end();
        return;
    }

    if( request.url.startsWith('/unregister/') ) {
        unregister( 'front', remote, () => {
          response.writeHead( 200 );
          response.end();
        } );
        return;
    }

    if( !request.url.startsWith('/call/') ) {
      response.writeHead( 404 );
      response.end();
      return;
    }

    // create document type "call"
    recordCall( remote, hostname, (err, results) => {
      if( err ) {
        console.log( err );
        response.writeHead( 500 );
        response.end();
      } else {
        response.setHeader('Content-Type', 'application/json');
        response.end( JSON.stringify( results ) );
      }
    } );

  }; // end handleRequest

  function recordCall( remoteName, local, callback ) {
    connect().insert(
      { "type": "call", "front": remoteName, "back": local, "ts": new Date() },
      function( err ) {
        if( err ) {
          callback( err );
        } else {
          connect().view( 'calls', 'type', { "group_level": 1 }, function(err, body){
            if( err ) {
              callback( err );
            } else {
              const results = {};
              body.rows.forEach( res => {
                results[ res.key ] = res.value;
              });
              callback( null, results );
            }
          });
        }
    }); // end insert
  }

  function register( type, name ) {
    connect().insert(
      {
        "type": "container",
        "image": type,
        "name": name,
        "status" : "started"
      },
      type + '-' + name
    );
  }

  function unregister( type, name, callback ) {
    connect().get( type + '-' + name, (err, body) => {
      if( err ) {
        callback();
      } else {
        body.status = "stopped";
        connect().insert( body, () => {
          console.log( "Container back unregistered");
          callback();
        });
      }
    });
  }

  function connect() {
    return nano({
      url: couchdbHost + dbname,
      requestDefaults: { "timeout" : "100" } // in miliseconds
    });
  }

})();
