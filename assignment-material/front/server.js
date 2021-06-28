(function() {
  'use strict';

  const hostname    = require("os").hostname(),
        port        = 3000,
        exitHook    = require('async-exit-hook'),
        http        = require('http');

  var backHost = 'http://back:9000';
  if( process.argv.length == 3 ) {
    backHost = 'http://' + process.argv[2] + ':9000';
  }
  console.log( 'Using ' + backHost + ' as back url' );

  http.createServer( handleRequest ).listen(port);
  console.log(`Server FRONT running at http://${hostname}:${port}/`);

  /* POST START INIT */

  // create container document with id=hostname and status "started"
  setTimeout( register, 5000, backHost, hostname );

  exitHook( callback => {
    // get and update container document with status = "stopped"
    http.get(backHost +'/unregister/'+ hostname, function( res ) {
      if( res.statusCode === 200 ) {
        console.log( 'Front ' + hostname + ' unregistered successfully' );
      } else {
        console.error( res.statusMessage );
      }
      callback();
    }).on('error', (e) => {
       console.error(`Got error: ${e.message}`);
       callback();
	});
  });

  /* REQUEST HANDLE FUNCTION */

  function handleRequest(request, response) {

    if( request.url === '/favicon.ico' ) {
      response.writeHead( 404 );
      response.end();
      return;
    }

    console.log( "Front: got request " + request.url );

    http.get(backHost + '/call/' + hostname, function( res ) {

      if( res.statusCode === 200 ) {
        let rawData = '';
        res.on('data', chunk => { rawData += chunk; });
        res.on('end', function() {
          response.setHeader('Content-Type', 'application/json');
          response.end( JSON.stringify( JSON.parse( rawData ) ) + '\n');
        });

      } else {
        console.log( res.statusMessage )
        response.writeHead( res.statusCode );
        response.end( res.statusMessage );
      }
    }).on('error', (e) => {
       console.error(`Got error: ${e.message}`);
    }); // end http.get
  }; // end handleRequest


  function register( backHost, hostname ) {
    http.get(backHost +'/register/'+ hostname, function( res ) {
      if( res.statusCode === 200 ) {
        console.log( `Front ${hostname} registered successfully` );
      } else {
        console.error( res.statusMessage );
      }
    }).on('error', (e) => {
  	  console.error(`Got error: ${e.message}`);
    });
  }

})();
