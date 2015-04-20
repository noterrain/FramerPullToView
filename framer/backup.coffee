# This imports all the layers for "pull to refresh" into pullToRefreshLayers
PSD = Framer.Importer.load "imported/pull to refresh"
# Pull to Refresh Bank project
#
# This example shows how to implement pull to fresh, as seen in the

# Initial set up. Import our PSD, set up global variables. We want to 
# hide our spinner layer until you let go (and have pulled enough)


# Variables
deltaY = 0
startY = 0

timelineStartY = PSD.timeline.y
utimelineStartY = PSD.arrow.y
stimelineStartY = PSD.spinner.y 
btimelineStartY = PSD.border.y
btimelineStartY3 = PSD.border.y - 110

springCurve = "spring(200,20,0)"
PSD.arrow.opacity = 0 
PSD.timeline.draggable.enabled = true
PSD.timeline.draggable.speedX = 0
PSD.timeline.draggable.speedY = 0.3
PSD.arrow.scale = 1
PSD.spinner.scale = 0
PSD.border.scale = 0

PSD.navbar.bringToFront
PSD.timeline.superLayer = PSD.bg
PSD.bg.clip = true
PSD.spinner.placeBefore(PSD.arrow)

# When you click (or taps), we need to grab the y position of 
# that click so that we can use it when you drag (to see how far 
# they have pulled. We also want to reset values for our refresh 
# control so everything is correct in case you pull to refresh 
# more than once.
PSD.timeline.on Events.DragStart, (event) ->
	startY = event.pageY
	PSD.spinner.opacity = 1
	PSD.border.rotation = 0
	PSD.spinner.animate({
		properties: {scale: 1}
		time: .3
		curve: 'spring(60,12,0)'
	})
	PSD.arrow.animate({
		properties: {opacity: 1, scale:1.1}
		time: 1
	})
	PSD.border.animate({
		properties: {scale: 1}
		time: .3
		curve: 'spring(60,12,0)'
	})
	
	    
# When you drag, several things should happen. The first is that
# the timeline should follow your mouse/finger. The arrow should
# also animate once you have pulled enough, letting you know you
# can release to refresh.
PSD.timeline.on Events.DragMove, (event) ->
	deltaY = startY - event.pageY
	PSD.timeline.y = (timelineStartY - deltaY)
	PSD.arrow.y = (utimelineStartY - deltaY - 40)
	PSD.spinner.y = (stimelineStartY - deltaY )
	PSD.border.y = (btimelineStartY3 - deltaY)
	
	
	# If you have pulled enough (in this case more than 140 pixels)
	# and if the arrow is not animating, then flip the arrow and
	# set animating to true. We do this so that the arrow doesn't 
	# try and animate each time you move, which would be very janky.
	# By using an animating variable, the animation only gets called
	# once, and is very smooth.

PSD.timeline.on Events.DragEnd, (event) ->
	    if deltaY >-140 
	       PSD.spinner.animate 
	          properties:
	              y:timelineStartY
	              scale: .3
	              opacity: 0
	              curve: "spring(800,80,0)"
	       PSD.border.animate
	          properties:
	              y: btimelineStartY
	              scale: 0
	              opacity: 0
	              curve: "spring(800,80,0)"
	       PSD.arrow.animate 
	          properties:
	              y:utimelineStartY
	              opacity: 0
	              curve: "spring(800,80,0)"
	       PSD.timeline.animate
	           properties:
	               y: timelineStartY
	               curve: "spring(800,80,0)"

	               
	    else
	       
	        PSD.arrow.animate
	           properties:
	              y: 350
	           curve: "spring(800, 60, 0)"
	        PSD.spinner.animate 
	            properties:
	                y: 250
	            curve:"spring(800, 60, 0)"
	        PSD.border.animate
	            properties: 
	                y: 200
	            curve: "spring(800, 60, 0)"
	        PSD.border.animate
	            properties: 
	                rotation: 1800
	            time: 4
	        prePause = PSD.timeline.animate
	            properties:
	                y: 250
	            curve: "spring(800,60,0)"
	        prePause.on "end", ->
	         	
		    Utils.delay 4, ->
		    	 PSD.border.animate
				     properties:
				        scale: 0 
				        y: btimelineStartY3
				     curve: springCurve
	    		 PSD.arrow.animate 
				     properties:
				         y: utimelineStartY
				         opacity: 0
				     curve: springCurve
				     time: .5
			     PSD.spinner.animate
				     properties:
					     scale: 0 
					     y:stimelineStartY
				     curve: springCurve	    
			     PSD.timeline.animate
				     properties:
					     y: timelineStartY 
				     curve: springCurve
				


       		