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

		return node

	_get_nodeExist: (prop, value) ->
		# set vars
		arr = []

		# check if value != undefined/null
		if value != undefined and value != null
			# set array with value
			arr.push [prop, value]

		return arr

	_get_funcArguments: (func) ->
		funStr = func.toString();
		return funStr
		#return funStr.slice(funStr.indexOf('(') + 1, funStr.indexOf(')')).match(/([^\s,]+)/g);



	#------------------
	# ---- all set fn
	#------------------
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

	_set_parameterCollection: (arg1, arg2) ->

		fn = @_set_parameterCollection
		console.log(@_get_funcArguments(fn))
		#set vars
		#items = ['tag', 'classes', 'attributes', 'content', 'styles']

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

	#------------------
	# ---- all build fn
	# -----------------

	# STEP 1. CREATE WRAPPER
	_build_structureWrap: ->
		# set vars
		component = this
		componentArray = []
		componentArray.push component
		pins = @_get_pins()

		@_set_parameterCollection('tag prova', 'cic')

		return false

		# build wrap -- tag: section -- class: paper-pull--builded--wrap
		wrap = @_build_element(
					obj = {
						type : 'section',
						classes : [['paper-pull--builded--wrap']],
						styles : [['maxWidth', @_get_nodeValue(componentArray, 0, 'wrapwidth') + 'px']]
					}
				)

		# build pins list -- tag: ul -- class: paper-pull--builded--list
		list = @_build_element(
					obj = {
						type : 'ul',
						classes : [['paper-pull--builded--list']]
					}
				)

		# build pin -- tag: li -- class: paper-pull--builded--cell
		for el, index in pins
			# set vars
			type = el.tagName.toLowerCase()

			# get pin width
			width = 'width:' + @_get_nodeValue(componentArray, 0, 'pinwidth') + 'px'

			# build pin -- tag: section -- class: paper-pull--builded--wrap
			pin = @_build_element(
					obj = {
						type : 'li',
						classes : [['paper-pull--builded--cell']],
						styles : [['width', @_get_nodeValue(componentArray, 0, 'pinwidth') + 'px']]
					}
				)

			# add pins to list
			list.appendChild pin

			# build article -- tag: article -- class: paper-pull--builded--article, paper-pull--type--[type]
			article = @_build_element(
						obj = {
							type : 'article',
							classes : [['paper-pull--builded--article'], ['paper-pull--type--' + type]],
							attributes : [['role', 'contentinfo'], ['aria-label', 'article']],
							styles : [['width', @_get_nodeValue(componentArray, 0, 'pinwidth') + 'px']]
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
				component.setAttribute('class', 'loaded')

		# add list to wrap
		wrap.appendChild list

		# add wrap to component
		component.appendChild wrap

	# STEP 2. CREATE CUSTOM TAG CONTENT [div, figure, iframe]
	# 1. default
	_build_default: ->

	# 2. image:
	_build_picture: (pin, index, type) ->
		ariaLabelLedBy =  @_get_nodeValue(@_get_pins(), index, 'aria-labelledby')

		# build custom tag -- tag: figure -- class: paper-pull--type--[type]--wrap
		tag = @_build_element(
					obj = {
						type : 'figure',
						classes : [['paper-pull--type--' + type + '--wrap']],
						attributes: [['aria-labelledby', ariaLabelLedBy]]
					}
				)

		# remove attribute
		@_remove_attributes(@_get_pin(index), 'aria-labelledby')

		#if @_build_relatedContent(index) != undefined && @_build_relatedContent(index) != null
			#tag.appendChild @_build_relatedContent(index)

		# add custom content to custom tag
		tag.appendChild @_build_content(index, type)

		return tag

	# 3. image:
	_build_youtube: (pin, index) ->
		tag = ''

		return tag

	# STEP 3. CREATE EACH CONTENT
	# fill custom case content
	_build_content: (index, type) ->
		# build custom content -- tag: [custom] -- attributes: [collection of attributes]
		tag = @_build_element(
					obj = {
						type : @_replace_tag(type),
						attributes : @_set_attributeCollection(index)
					}
				)

		return tag

	# STEP 4. CREATE RELATED CONTENT [title, claim,, description]
	_build_relatedContent: (index) ->
		#get title
		title = @_get_nodeValue(@_get_pins(), index, 'title')
		claim = @_get_nodeValue(@_get_pins(), index, 'claim')
		description = @_get_nodeValue(@_get_pins(), index, 'description')

		if title != undefined && title != null || claim != undefined && claim != null
			# build header -- tag: header -- class: paper-pull--short--header
			header = @_build_element(
					obj = {
						type : 'header',
						classes : [['paper-pull--short--header']],
					}
				)


			# check if title exist
			# add title to header
			if title != undefined && title != null

				# build title -- tag: h2 -- class: paper-pull--short--header
				title = @_build_element(
					obj = {
						type : 'h2',
						classes : [['paper-pull--short--title']],
						content : title
					}
				)

				header.appendChild title

				# remove attribute
				@_remove_attributes(@_get_pin(index), 'title')

			# check if claim exist
			# add claim to header
			if claim != undefined && claim != null
				# build claim -- tag: h2 -- class: paper-pull--short--header
				claim = @_build_element(
					obj = {
						type : 'h3',
						classes : [['paper-pull--short--claim']],
						content : claim
					}
				)

				header.appendChild claim

				# remove attribute
				@_remove_attributes(@_get_pin(index), 'claim')

			return header

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
		@_test()
	ready: ->

	_onLoad: ->

	_onResize: ->


	#------------------
	# ---- test
	# -----------------
	_test : ->
		component = []
		component.push @
		@_build_structureWrap()
		#@_get_nodeValue(@_get_pins(), 0, 'jjj')

