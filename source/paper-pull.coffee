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
	_get_component: ->
		component = this
		componentArray = []
		componentArray.push component

		return componentArray

	_get_windowWidth: ->
		# get value
		winWidth = window.innerWidth

		return winWidth

	_get_pins: ->
		# set vars
		component = this

		# get pins elements
		pull = component.querySelector('.paper-pull-wrap')
		pins = pull.getElementsByTagName('*')

		return pins

	_get_pin: (index) ->
		# get pins
		pins = @_get_pins()

		# get pin by index
		pin = pins[index]

		return pin

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

	_get_pinLeftPosition: (index, spaceLeft) ->
  		# set vars
  		pinWidth = if @_get_nodeValue(@_get_component(), 0, 'pinwidth') then parseFloat @_get_nodeValue(@_get_component(), 0, 'pinwidth') else @_set_defaultValue('pinWidth')
  		pinMargin = if @_get_nodeValue(@_get_component(), 0, 'pinspace') then parseFloat @_get_nodeValue(@_get_component(), 0, 'pinspace') else @_set_defaultValue('pinMargin')
  		left = (pinMargin + (index * (pinWidth + pinMargin))) + spaceLeft

  		return left

	_get_allAttributes: (obj) ->
		# set vars
		attrs = obj.attributes

		return attrs

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

		return temp

	_get_nodeValue: (obj, index, prop) ->
		# set obj collection
		arr = @_set_nodesValues(obj)

		# get prop value
		if prop != null && prop != undefined
			node = arr[index][prop]
		# get node value
		else
			node = arr[index]

		if node != undefined && node != null
			return node
		else
			return false

	_get_nodeExist: (prop, value) ->
		# set vars
		arr = []

		# check if value != undefined/null
		if value != undefined and value != null
			# set array with value
			arr.push [prop, value]

		return arr

	_get_propertyExist: (array, prop) ->
		return array.hasOwnProperty(prop)

	_get_minValueInArray: (array) ->
  		Math.min.apply Math, array

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

	#------------------
	# ---- all set fn
	#------------------
	_set_defaultValue: (prop) ->
		defaultValues = [{
				pinWidth : 300,
				pinMargin : 0
			}]

		return defaultValues[0][prop]

	_set_pinConfPosition: ->
		# set vars
		cell = @.querySelectorAll('.paper-pull--builded--cell')
		pinMargin = if @_get_nodeValue(@_get_component(), 0, 'pinspace') then parseFloat @_get_nodeValue(@_get_component(), 0, 'pinspace') else @_set_defaultValue('pinMargin')
		pinMarginArray = []

		# get column number
		count = @_get_pinColumn()

		# add item to array
		for c, index in cell
			if index < count
				pinMarginArray.push pinMargin

		# call: set_pinNewPosition
		@_set_pinNewPosition(pinMarginArray)

	_set_pinNewPosition : (array) ->
		# set vars
		cell = @.querySelectorAll('.paper-pull--builded--cell')
		wrap = @.querySelector('.paper-pull--builded--wrap')
		wrapWidth = wrapWidth = wrap.clientWidth
		pinWidth = if @_get_nodeValue(@_get_component(), 0, 'pinwidth') then parseFloat @_get_nodeValue(@_get_component(), 0, 'pinwidth') else @_set_defaultValue('pinWidth')
		pinMargin = if @_get_nodeValue(@_get_component(), 0, 'pinspace') then parseFloat @_get_nodeValue(@_get_component(), 0, 'pinspace') else @_set_defaultValue('pinMargin')
		centeredMode = @_get_nodeValue(@_get_component(), 0, 'centered')

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

			# get min array value
			min = @_get_minValueInArray(array)

			# get index of min array value
			index = @_get_indexInArray(min, array)

			# set new left + new top position
			c.style.left = @_get_pinLeftPosition(index, spaceLeft) + 'px'
			c.style.top = min + 'px'

			array[index] = min + height + pinMargin

	_set_attributeCollection: (index) ->
		# set vars
		arr = []

		# get parameters
		parameters = @_get_nodeValue(@_get_pins(), index)

		# iterate obj
		Object.getOwnPropertyNames(parameters).forEach (val, idx, array) ->
			# set prop
			prop = val

			# set value
			value = parameters[val]

			# fill array
			arr.push [prop, value]

		return arr

	_set_nodesValues: (obj) ->
		# set vars
		arr = []

		# iterate pins
		for el, index in obj

			# get attributes
			attrs = @_get_allAttributes(el)

			# fill array arr[]
			arr.push @_get_allAttributeValues(attrs)

		return arr


	#------------------
	# ---- all build fn
	# -----------------

	# STEP 1. CREATE WRAPPER
	_build_structureWrap: ->
		# set vars
		component = this
		pins = @_get_pins()
		maxWidth = if @_get_nodeValue(@_get_component(), 0, 'wrapwidth') then parseFloat @_get_nodeValue(@_get_component(), 0, 'wrapwidth') else @_get_windowWidth()


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
		for el, index in pins
			# set vars
			type = el.tagName.toLowerCase()

			# get pin width
			width = if @_get_nodeValue(@_get_component(), 0, 'pinwidth') then parseFloat @_get_nodeValue(@_get_component(), 0, 'pinwidth') else @_set_defaultValue('pinWidth')

			# build pin
			# tag: section
			# class: paper-pull--builded--wrap
			# innerStyle: [width]
			pin = @_build_element(
					obj = {
						type : 'li',
						classes : [['paper-pull--builded--cell']],
						styles : [['width', width + 'px']]
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
			article.appendChild @[customType](pin, index, type)

			# set class when all pins are loaded
			if index == (pins.length - 1)
				@.setAttribute('class', 'loaded')

			# add list to wrap
			wrap.appendChild list

			# add wrap to component
			@.appendChild wrap

		# temp fn to solve
		# repositioning
		# setTimeout (->
		# 	# set pins position
		# 	component._set_pinConfPosition()
		# 	return
		# ), 200

	# STEP 2. CREATE CUSTOM TAG CONTENT [div, figure, iframe]
	# 1. default
	_build_text: (pin, index, type) ->
		# set vars
		component = this

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
		header = @_build_relatedContent('header', index, 'header')
		if header
			tag.appendChild header

		# if related description exist
		# add it to custom tag
		description = @_build_relatedContent('description', index, 'p')
		if description
			tag.appendChild description

			# set pins position
			component._set_pinConfPosition()

		return tag

	# 2. image:
	_build_picture: (pin, index, type) ->
		# set vars
		component = this
		ariaLabelLedBy =  @_get_nodeValue(@_get_pins(), index, 'aria-labelledby')
		src = @_get_nodeValue(@_get_pins(), index, 'src')

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
		@_remove_attributes(@_get_pin(index), 'aria-labelledby')

		# if related header exist
		# add it to custom tag
		header = @_build_relatedContent('header', index, 'header')
		if header
			tag.appendChild header


		# if related description exist
		# add it to custom tag
		description = @_build_relatedContent('description', index, 'figcaption')
		if description
			tag.appendChild description

		# store content in var
		content = @_build_content(index, type)

		# asynchronous load image
		# set vars
		newImg = new Image()

		# crete load event
		newImg.onload = ->
			content.src = this.src

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
		if @_get_nodeValue(@_get_pins(), index, 'href')
			anchor = @_build_element(
						obj = {
							type : 'a',
							attributes: [['href', @_get_nodeValue(@_get_pins(), index, 'href')], ['target', '_blank']]
						}
					)

			# add anchor to tag
			anchor.appendChild tag

			# set tag var with anchor obj content
			tag = anchor

		return tag

	# 3. video youtube:
	_build_youtube: (pin, index, type) ->
		# set vars
		component = @
		url = @_get_nodeValue(@_get_pins(), index, 'video')
		newUrl = url.replace('/watch?v=', '/embed/')
		ariaLabelLedBy =  @_get_nodeValue(@_get_pins(), index, 'aria-labelledby')

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
	_build_content: (index, type) ->
		# build custom content
		# tag: [custom]
		# attributes: [collection of attributes]
		tag = @_build_element(
					obj = {
						type : @_replace_tag(type),
						attributes : @_set_attributeCollection(index)
					}
				)

		return tag

	# STEP 4. CREATE RELATED CONTENT
	_build_relatedContent: (type, index, tag) ->
		fn = '_build_related_' + type
		@[fn](type, index, tag)

	# 4.1 CREATE RELATED HEADER [title, claim]
	_build_related_header: (type, index, tag) ->

		# check if title || claim exist
		if @_get_nodeValue(@_get_pins(), index, 'title') || @_get_nodeValue(@_get_pins(), index, 'claim')

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
			if @_get_nodeValue(@_get_pins(), index, 'title')

				# build custom tag
				# tag: h2
				# class: paper-pull--short--title
				# innerContent: [title]
				el = @_build_element(
					obj = {
						type : 'h2',
						classes : [['paper-pull--short--title']],
						content : @_get_nodeValue(@_get_pins(), index, 'title')
					}
				)

				# add title to header
				header.appendChild (el)

				# remove attribute title
				@_remove_attributes(@_get_pin(index), 'title')

			# check if claim exist
			if @_get_nodeValue(@_get_pins(), index, 'claim')

				# build custom tag
				# tag: h2
				# class: paper-pull--short--title
				# innerContent: [claim]
				el = @_build_element(
					obj = {
						type : 'h3',
						classes : [['paper-pull--short--claim']],
						content : @_get_nodeValue(@_get_pins(), index, 'claim')
					}
				)

				# add title to header
				header.appendChild (el)

				# remove attribute claim
				@_remove_attributes(@_get_pin(index), 'claim')

			return header
		else
			return false

	# 4.2 CREATE RELATED DESCRIPTION [description]
	_build_related_description: (type, index, tag) ->
		if @_get_nodeValue(@_get_pins(), index, 'description')

			# build custom tag
			# tag: [tag]
			# class: paper-pull--short-- + [type]
			# innerContent: [description]
			description = @_build_element(
				obj = {
					type : tag,
					classes : [['paper-pull--short--' + type]],
					content : @_get_nodeValue(@_get_pins(), index, 'description')
				}
			)

			# remove attribute description
			@_remove_attributes(@_get_pin(index), 'description')

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
	_remove_attributes: (pin, attr) ->
		# remove chooses attributes
		pin.removeAttribute(attr)

	# -----------------
	# ---- all events
	# -----------------

	attached: ->
		@_build_structureWrap()
		#@_test()

	ready: ->

	_onLoad: ->

	_onResize: ->
		# set vars
		component = this
		if component.classList.contains('loaded')
			@_set_pinConfPosition()

	#------------------
	# ---- test
	# -----------------
	_test : ->
		component = []
		component.push @
		@_get_externalFile("object.json", (response) -> 
			json = JSON.parse response
			return json.pins[0])
		#@_build_structureWrap()
		#@_get_nodeValue(@_get_pins(), 0, 'jjj')


	# ------------------- temp ------------------------
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


	# -------------------------------------------------

