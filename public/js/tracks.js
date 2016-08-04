
var eC;var nC;var canvas;var ctx;var paths = [];var new_path = {};var apiURL;
apiURL = "https://localhost:3000/access/a102938012938/content/movements/1.json";

		/** Create canvas **/
		 eC = 'canvas'+$('canvas').length;
		 nC = $('<canvas/>')
		    .attr({
		    	id: eC
		    })
		    .css({
		    marginLeft: 0, marginTop: 0, position: "absolute",
		    top: 0, left: 0, zIndex: 60, float: "left"
		}).css('pointer-events', 'none').appendTo('body');
		 canvas = document.getElementById(eC);
		ctx = canvas.getContext("2d");
		  ctx.canvas.width  = window.innerWidth;
		  ctx.canvas.height = window.innerHeight;

		

		var prevTrack = 0;
		function genNewPath(track){
			if (prevTrack != track ){
			 new_path = 			
			  {
			    lineWidth: 4,
			    stroke: getRandomColor(),
			    points: []
		      };
		      paths.push(new_path);
			}
			prevTrack = track;

		};
			$.getJSON(apiURL, function(data) {
		        $.each(data, function(index) {
		        	genNewPath(data[index].track_id);
		            newPoint(data[index].x, data[index].y, new_path);
		        });
			draw();
		    });


		function newPoint(x, y, path) {
		    path.points.push({
		        x: x,
		        y: y
		    });
		}

		function draw() {
			$(function(){
			    ctx.clearRect(0, 0, canvas.width, canvas.height);

			    for (p = 0; p < paths.length; p++) {

			        var path = paths[p];
			        let firstx = path.points[0].x;
			        let firsty = path.points[0].y;
			        let path_size = path.points.length-1;
			        let prevx = firstx;
			        let prevy = firsty;
			        for (pt = 1; pt < path.points.length; pt++) {
			        ctx.beginPath();

			        ctx.moveTo(prevx, prevy);
			        var point = path.points[pt];
			        ctx.lineTo(point.x, point.y);

			        ctx.strokeStyle = path.stroke;
			        if(pt > path.points.length-2){
			        	ctx.lineWidth = (path.lineWidth*(10*pt))/path_size;
			    	} else {
			    		ctx.lineWidth = path.lineWidth;
			    	}
			        ctx.stroke();
			        prevx = point.x;
			        prevy = point.y;
			          if(pt == path.points.length -1 ){
			          	ctx.fillStyle= "#FF0000";;
			          	ctx.lineWidth = 0.5;
				        ctx.beginPath();
				        ctx.moveTo(firstx, firsty);
				        ctx.lineTo(point.x, point.y);
				        ctx.stroke();
				    }
			      
			      }

			    }
			});

		};
		function getRandomColor() {
		    var letters = '0123456789ABCDEF'.split('');
		    var color = '#';
		    for (var i = 0; i < 6; i++ ) {
		        color += letters[Math.floor(Math.random() * 16)];
		    }
		    return color;
		};