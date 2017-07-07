Polymer
	is: 'paper-pull'

	behaviors: [
		Polymer.IronResizableBehavior
	]

	listeners:
		'iron-resize': '_onResize'

	#------------------
	# ---- all get fn
	# -----------------

	# get component obj
	# and put it in array
	_get_component: ->
		# set vars
		component = this
		attrs = @_get_allAttributes(component)
		main = {}

		# fill main array
		main =  @_get_allValues(attrs)

		return main

	# get user window width
	_get_windowWidth: ->
		# get value
		winWidth = window.innerWidth

		return parseFloat winWidth

	# get how many column
	# we need to fit the wrap
	_get_pinColumn: ->
		# set vars
		wrap = @.querySelector('.paper-pull--builded--wrap')
		wrapWidth = wrap.clientWidth
		pinWidth = if @_get_nodeValue(@_get_component(), 0, 'pinwidth') then parseFloat @_get_nodeValue(@_get_component(), 0, 'pinwidth') else @_set_defaultValue('pinWidth')
		pinMargin = if @_get_nodeValue(@_get_component(), 0, 'pinspace') then parseFloat @_get_nodeValue(@_get_component(), 0, 'pinspace') else @_set_defaultValue('pinMargin')
		centeredMode = @_get_nodeValue(@_get_component(), 0, 'centered')

		# set coloumn
		if centeredMode != null and centeredMode != undefined and centeredMode != 'false'
			count = Math.floor(wrapWidth / (pinWidth + pinMargin * 2))
		else
			count = Math.floor(wrapWidth / (pinWidth + pinMargin))

		return parseFloat count

	# get left position
	# for every element
	_get_pinLeftPosition: (index, spaceLeft) ->
  		# set vars
  		pinWidth = if @_get_nodeValue(@_get_component(), 'pinwidth') then parseFloat @_get_nodeValue(@_get_component(), 'pinwidth') else @_set_defaultValue('pinWidth')
  		pinMargin = if @_get_nodeValue(@_get_component(), 'pinspace') then parseFloat @_get_nodeValue(@_get_component(), 'pinspace') else @_set_defaultValue('pinMargin')
  		left = (pinMargin + (index * (pinWidth + pinMargin))) + spaceLeft

  		return left

  	# get all prop name
  	# for a passed obj
	_get_allAttributes: (obj) ->
		# set vars
		attrs = obj.attributes

		return attrs

	# get all prop values
	# for passed obj
	_get_allAttributeValues: (obj)->
		# set vars
		node = ''
		value = ''
		temp = {}

		# parse array
		for attr, index in obj

			# get attribute name && attribute value
			node = attr.nodeName
			value = attr.nodeValue

			# set temp array
			temp[node] = value

			console.log temp
		return temp

	# get a value of an array node
	# or get all array obj
	_get_nodeValue: (obj, prop) ->
		# set obj collection
		arr = obj

		# get prop value
		if prop != null && prop != undefined
			node = arr[prop]
		# get node value
		else
			node = arr

		if node != undefined && node != null
			return node
		else
			return false

	# get node if exist
	_get_nodeExist: (prop, value) ->
		# set vars
		arr = []

		# check if value != undefined/null
		if value != undefined and value != null
			# set array with value
			arr.push [prop, value]

		return arr

	# get prop if exist
	_get_propertyExist: (array, prop) ->
		return array.hasOwnProperty(prop)

	# get min value for
	# a passed array
	_get_minValueInArray: (array) ->
  		Math.min.apply Math, array

  	# get a index value
  	# for node in a passed array
	_get_indexInArray: (elem, array) ->
		# set vars
		length = array.length

		# parse array
		for el, index in array

			# check if elem == array[i]
			if elem == parseFloat el
				# return index value
				return index

		return false

	# get all value, prop name 
	# and prop value, for a passed obj
	_get_allValues: (obj)->
		# set vars
		node = ''
		value = ''
		temp = {}

		# parse array
		for attr, index in obj

			# get attribute name && attribute value
			node = attr.nodeName
			value = attr.nodeValue

			# set temp array
			temp[node] = value

		return temp

	# load an external file
	# use it to load the xml with pins
	_get_externalFile: (file, fn) ->
		# set vars
		component = this
		xmlhttp = new XMLHttpRequest()

		xmlhttp.onreadystatechange = ->
			if xmlhttp.readyState == 4

				# status ok
				if xmlhttp.status == 200
					if typeof fn == 'function'
						# pass the result to custom fn
                		fn xmlhttp.responseText ;

				# status 'not found'
				else if xmlhttp.status == 400
					console.log 'not found'

				# status 'error'
				else
					console.log 'error'
			return

		xmlhttp.open("GET", file, true);
		xmlhttp.send();

		return xmlhttp

	# get mobile version [true, false]
	_get_responsive: ->
		responsive = @_get_windowWidth() >= parseFloat @_set_defaultValue('mobile')

		return responsive
	#------------------
	# ---- all set fn
	#------------------

	# set init value
	_set_defaultValue: (prop) ->
		defaultValues = [{
				pinWidth : 300,
				pinMargin : 0,
				mobile : 680
			}]

		return defaultValues[0][prop]

	# set value for positioning
	# the pins.
	# fill the array with margins
	_set_pinConfPosition: ->
		# set vars
		cell = @.querySelectorAll('.paper-pull--builded--cell')
		pinMargin = if @_get_nodeValue(@_get_component(), 'pinspace') then parseFloat @_get_nodeValue(@_get_component(), 'pinspace') else @_set_defaultValue('pinMargin')
		pinMarginArray = []

		# get column number
		count = @_get_pinColumn()

		# add item to array
		for c, index in cell
			if index < count
				pinMarginArray.push pinMargin

		# call: set_pinNewPosition
		@_set_pinNewPosition(pinMarginArray)

	# set for each element new position, top and left.
	# set the total height for wrap element
	_set_pinNewPosition : (array) ->
		# set vars
		arrayTop = []
		arrayHeight = []
		arraySum = []
		wrap = @.querySelector('.paper-pull--builded--wrap')
		cell = @.querySelectorAll('.paper-pull--builded--cell')
		wrapWidth = wrapWidth = wrap.clientWidth
		pinWidth = if @_get_nodeValue(@_get_component(), 'pinwidth') then parseFloat @_get_nodeValue(@_get_component(), 'pinwidth') else @_set_defaultValue('pinWidth')
		pinMargin = if @_get_nodeValue(@_get_component(), 'pinspace') then parseFloat @_get_nodeValue(@_get_component(), 'pinspace') else @_set_defaultValue('pinMargin')
		centeredMode = @_get_nodeValue(@_get_component(), 'centered')

		# set var spaceLeft
		if centeredMode != null and centeredMode != undefined and centeredMode != 'false'
			spaceLeft = (wrapWidth - (( pinWidth * @_get_pinColumn() ) + ( pinMargin * ( @_get_pinColumn() - 1 )))) / 2;
		else
			spaceLeft = 0

		# set column size
		count = @_get_pinColumn()

		for c in cell
			# get element height
			height = c.clientHeight

			# set element height
			width = if @_get_nodeValue(@_get_component(), 'pinwidth') then parseFloat @_get_nodeValue(@_get_component(), 'pinwidth') else @_set_defaultValue('pinWidth')

			# get min array value
			min = @_get_minValueInArray(array)

			# get index of min array value
			index = @_get_indexInArray(min, array)

			# set new left + new top position
			c.style.left = @_get_pinLeftPosition(index, spaceLeft) + 'px'
			c.style.top = min + 'px'
			c.style.width = width + 'px'

			array[index] = min + height + pinMargin

			# fill arrays for max top position
			# and relative height element
			arrayTop.push min
			arrayHeight.push height

		# find top of last items [by count value]
		sliceTop = arrayTop.slice((arrayTop.length - count), arrayTop.length)

		# find height of last items [by count value]
		sliceHeight = arrayHeight.slice((arrayHeight.length - count), arrayHeight.length)

		for node, index in sliceTop
			arraySum.push sliceTop[index] + sliceHeight[index]

		maxSum = Math.max.apply(null, arraySum)

		#[maxSum] + [margin]
		wrap.style.height = maxSum + pinMargin + 'px' ;

	# set a collection of attributes
	# to use it in pin build
	_set_attributeCollection: (node) ->
		# set vars
		arr = []

		# get parameters
		parameters = node

		# iterate obj
		Object.getOwnPropertyNames(parameters).forEach (val, idx, array) ->
			# set prop
			prop = val

			# set value
			value = parameters[val]

			# fill array
			arr.push [prop, value]

		return arr

	_set_attribute: (objs, prop, value) ->
		for obj in objs
			obj.setAttribute prop value

	#------------------
	# ---- all build fn
	# -----------------

	# STEP 1. CREATE WRAPPER
	_build_structureWrap: (parsedJson) ->

		# set vars
		component = this
		maxWidth = if @_get_nodeValue(@_get_component(), 'wrapwidth') then parseFloat @_get_nodeValue(@_get_component(), 'wrapwidth') else @_get_windowWidth()

		# build wrap
		# tag: section
		# class: paper-pull--builded--wrap
		# inlineStyle: [max-width]
		wrap = @_build_element(
					obj = {
						type : 'section',
						classes : [['paper-pull--builded--wrap']],
						styles : [['maxWidth', maxWidth + 'px']]
					}
				)

		# add wrap to component
		@.appendChild wrap

		# build pins list
		# tag: ul
		# class: paper-pull--builded--list
		list = @_build_element(
					obj = {
						type : 'ul',
						classes : [['paper-pull--builded--list']]
					}
				)

		# build pin
		# tag: li
		# class: paper-pull--builded--cell
		for node, index in parsedJson

			# set vars
			type = node.tagName

			# get pin width
			width = if @_get_nodeValue(@_get_component(), 'pinwidth') then parseFloat @_get_nodeValue(@_get_component(), 'pinwidth') else @_set_defaultValue('pinWidth')

			# build pin
			# tag: section
			# class: paper-pull--builded--wrap
			# innerStyle: [width]
			pin = @_build_element(
					obj = {
						type : 'li',
						classes : [['paper-pull--builded--cell']]
						#styles : [['width', width + 'px']]
					}
				)

			# add pins to list
			list.appendChild pin

			# build article
			# tag: article
			# class: paper-pull--builded--article, paper-pull--type--[type]
			# attribute: role, aria-label
			# innerStyle: [width]
			article = @_build_element(
						obj = {
							type : 'article',
							classes : [['paper-pull--builded--article'], ['paper-pull--type--' + type]],
							attributes : [['role', 'contentinfo'], ['aria-label', 'article']]
						}
					)

			# add article to pin
			pin.appendChild article

			# custom pin content
			customType = '_build_' + type

			# add customType to article
			article.appendChild @[customType](pin, node)

			# set class when all pins are loaded
			if index == (parsedJson.length - 1)
				@.setAttribute('class', 'loaded')

			# add list to wrap
			wrap.appendChild list

			# add wrap to component
			@.appendChild wrap

	# STEP 2. CREATE CUSTOM TAG CONTENT [div, figure, iframe]
	# 1. default
	_build_default: (pin, node, type) ->
		# set vars
		component = this
		type = @_get_nodeValue(node , 'tagName')

		# build custom tag
		# tag: div
		# class: paper-pull--type--[type]--wrap
		tag = @_build_element(
					obj = {
						type : 'div',
						classes : [['paper-pull--type--' + type + '--wrap']]
					}
				)

		# if related header exist
		# add it to custom tag
		header = @_build_relatedContent('header', node, 'header')
		if header
			tag.appendChild header

		# if related description exist
		# add it to custom tag
		description = @_build_relatedContent('description', node, 'p')
		if description
			tag.appendChild description

		return tag

	# 2. image:
	_build_picture: (pin, node) ->
		# set vars
		component = this
		ariaLabelLedBy =  @_get_nodeValue(node , 'aria-labelledby')
		src = @_get_nodeValue(node, 'src')
		type = @_get_nodeValue(node , 'tagName')

		# build custom tag
		# tag: figure
		# class: paper-pull--type--[type]--wrap
		# attribute: [aria-labelledby]
		tag = @_build_element(
					obj = {
						type : 'figure',
						classes : [['paper-pull--type--' + type + '--wrap']],
						attributes: [['aria-labelledby', ariaLabelLedBy]]
					}
				)

		# remove attribute
		@_remove_node(node, 'aria-labelledby')

		# if related header exist
		# add it to custom tag
		header = @_build_relatedContent('header', node, 'header')
		if header
			tag.appendChild header


		# if related description exist
		# add it to custom tag
		description = @_build_relatedContent('description', node, 'figcaption')
		if description
			tag.appendChild description

		# store content in var
		content = @_build_content(node)

		# asynchronous load image
		# set vars
		newImg = new Image()

		# crete load event
		newImg.onload = ->
			content.src = this.src

			# get mobile version
			if component._get_responsive()
				# set pins position
				# with little delay
				setTimeout ( ->
					component._set_pinConfPosition()
					return
				), 400

		# set dynamic source image
		newImg.src = src

		# add custom content to custom tag
		tag.appendChild content

		# check if node href exist to put a link
		if @_get_nodeValue(node, 'href')
			anchor = @_build_element(
						obj = {
							type : 'a',
							attributes: [['href', @_get_nodeValue(node, 'href')], ['target', '_blank']]
						}
					)

			# add anchor to tag
			anchor.appendChild tag

			# set tag var with anchor obj content
			tag = anchor

		return tag

	# 3. video youtube:
	_build_youtube: (pin, node) ->
		# set vars
		component = @
		type = @_get_nodeValue(node , 'tagName')
		url = @_get_nodeValue(node, 'video')
		newUrl = url.replace('/watch?v=', '/embed/')
		ariaLabelLedBy =  @_get_nodeValue(node, 'aria-labelledby')

		# check url type
		if url.indexOf('youtube.com/watch?v=') > -1
			src = newUrl + '?autoplay=0'
		else
			src = url + '?autoplay=0'

		# build iframe wrap
		# tag: div
		# class: paper-pull--type--iframe--wrap
		wrap = @_build_element(
					obj = {
						type : 'div',
						classes : [['paper-pull--type--iframe--wrap']]
					}
				)

		# build custom tag
		# tag: iframe
		# class: paper-pull--type--[type]--wrap
		# attribute: [aria-labelledby], [frameborder], [allowfullscreen], [src]
		tag = @_build_element(
					obj = {
						type : 'iframe',
						classes : [['paper-pull--type--' + type + '--wrap']],
						attributes: [['aria-labelledby', ariaLabelLedBy], ['frameborder', '0'], ['allowfullscreen', ''], ['src', src]]
					}
				)

		# add tag to wrap
		wrap.appendChild tag

		#return false
		return wrap

	# STEP 3. CREATE EACH CONTENT
	# fill custom case content
	_build_content: (node) ->
		# set vars
		type = @_get_nodeValue(node , 'tagName')

		# remove attribute
		@_remove_node(node, 'tagName')

		# build custom content
		# tag: [custom]
		# attributes: [collection of attributes]
		tag = @_build_element(
					obj = {
						type : @_replace_tag(type),
						attributes : @_set_attributeCollection(node)
					}
				)

		return tag

	# STEP 4. CREATE RELATED CONTENT
	_build_relatedContent: (type, node, tag) ->
		fn = '_build_related_' + type
		@[fn](type, node, tag)

	# 4.1 CREATE RELATED HEADER [title, claim]
	_build_related_header: (type, node, tag) ->

		# check if title || claim exist
		if @_get_nodeValue(node, 'title') || @_get_nodeValue(node, 'claim')

			# build custom tag
			# tag: header
			# class: paper-pull--short--[type]
			header = @_build_element(
				obj = {
					type : tag,
					classes : [['paper-pull--short--' + type]]
				}
			)

			# check if title exist
			if @_get_nodeValue(node, 'title')

				# build custom tag
				# tag: h2
				# class: paper-pull--short--title
				# innerContent: [title]
				el = @_build_element(
					obj = {
						type : 'h2',
						classes : [['paper-pull--short--title']],
						content : @_get_nodeValue(node, 'title')
					}
				)

				# add title to header
				header.appendChild (el)

				# remove attribute title
				@_remove_node(node, 'title')

			# check if claim exist
			if @_get_nodeValue(node, 'claim')

				# build custom tag
				# tag: h2
				# class: paper-pull--short--title
				# innerContent: [claim]
				el = @_build_element(
					obj = {
						type : 'h3',
						classes : [['paper-pull--short--claim']],
						content : @_get_nodeValue(node, 'claim')
					}
				)

				# add title to header
				header.appendChild (el)

				# remove attribute claim
				@_remove_node(node, 'claim')

			return header
		else
			return false

	# 4.2 CREATE RELATED DESCRIPTION [description]
	_build_related_description: (type, node, tag) ->
		if @_get_nodeValue(node, 'description')

			# build custom tag
			# tag: [tag]
			# class: paper-pull--short-- + [type]
			# innerContent: [description]
			description = @_build_element(
				obj = {
					type : tag,
					classes : [['paper-pull--short--' + type]],
					content : @_get_nodeValue(node, 'description')
				}
			)

			# remove attribute description
			@_remove_node(node, 'description')

			return description
		else
			return false

	# build tag element + add class - attributes - inner content - inline style
	# params:
	# 1. tag
	# 2. classes
	# 3. attributes
	# 4. content
	# 5. inline styles
	_build_element: (obj) ->
		elem = document.createElement obj.type

		# set class
		if obj.classes != null && obj.classes != undefined
			for arr, index in obj.classes
				elem.className += obj.classes[index] + ' '

		# set attribute
		if obj.attributes != null && obj.attributes != undefined
			for arr, index in obj.attributes
				if obj.attributes[index][1] != null && obj.attributes[index][1] != undefined
					elem.setAttribute obj.attributes[index][0], obj.attributes[index][1]

		# set innerHTML
		if obj.content != null && obj.content != undefined
			elem.innerHTML = obj.content

		# set inline styles
		if obj.styles != null && obj.styles != undefined
			for arr, index in obj.styles
				elem.style[obj.styles[index][0]] = obj.styles[index][1]

		return elem

	#------------------
	# ---- all replace fn
	# -----------------
	_replace_tag: (toReplace) ->
		# check tag to replace
		switch toReplace
  			when 'picture'
  				newTag = 'img'

  			when 'default'
  				newTag = 'p'

  		return newTag

	#------------------
	# ---- all remove fn
	# -----------------
	_remove_node: (node, prop) ->
		# remove chooses attributes
		delete node[prop]

	_remove_attr: (objs, attr) ->
		for obj in objs
    		obj.removeAttribute(attr);

	# -----------------
	# ---- all events
	# -----------------

	attached: ->
		# set vars
		component = this

		# load external value to
		# build all pins
		@_get_externalFile(@_get_nodeValue(@_get_component(), 'source'), (response) ->
				# get json nodes
				json = JSON.parse response

				# build structure
				component._build_structureWrap(json.pins)
			)

	ready: ->

	_onLoad: ->

	_onResize: ->
		# set vars
		component = this

		console.log @_get_responsive()

		# check device width
		if @_get_responsive()
			# check if all pins are loaded
			if component.classList.contains('loaded')

				# set pin config
				# to their positioning
				@_set_pinConfPosition()
		else
			# set vars
			cell = @.querySelectorAll('.paper-pull--builded--cell')

			# remove attr style to cell
			# for responsive version
			@_remove_attr(cell, 'style')

	#------------------
	# ---- test
	# -----------------
	_test : ->
		component = []
		component.push @
		@_get_externalFile(@_get_nodeValue(@_get_component(), 'source'), (response) ->
			json = JSON.parse response
			return json.pins[0])
		#@_build_structureWrap()
		#@_get_nodeValue(@_get_pins(), 0, 'jjj')

