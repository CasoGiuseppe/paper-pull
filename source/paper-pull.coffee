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

		# get node value
		node = arr[index][prop]

		return node

	_get_nodeExist: (prop, value) ->
		# set vars
		arr = []

		# check if value != undefined/null
		if value != undefined and value != null
			# set array with value
			arr.push [prop, value]

		return arr


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

	#------------------
	# ---- all build fn
	# -----------------
	_build_structure: ->
		# set vars
		component = this
		componentArray = []
		componentArray.push component
		pins = @_get_pins()


		# build wrap -- tag: section -- class: paper-pull--builded--wrap
		# params:
		# 1. tag
		# 2. classes
		# 3. attributes
		# 4. innerContent
		# 5. inline styles
		wrap = @_build_element(
					obj = {
						type : 'section',
						classes : [['paper-pull--builded--wrap']],
						styles : [['maxWidth', @_get_nodeValue(componentArray, 0, 'wrapwidth') + 'px']]
					}
				)

		# build pins list -- tag: ul -- class: paper-pull--builded--list
		# param:
		# 1. tag
		# 2. classes
		# 3. attributes
		# 4. innerContent
		# 5. inline styles
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
			# params:
			# 1. tag
			# 2. classes
			# 3. attributes
			# 4. innerContent
			# 5. inline styles
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
			# params:
			# 1. tag
			# 2. classes
			# 3. attributes
			# 4. innerContent
			# 5. inline styles
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
			console.log @[customType](el, index, type)
			article.appendChild @[customType](el, index, type)

			# set class when all pins are loaded
			if index == (pins.length - 1)
				component.setAttribute('class', 'loaded')

		# add list to wrap
		wrap.appendChild list

		# add wrap to component
		component.appendChild wrap

	# build custom element
	# obj : tag + classes + attr + inline content + inline styles
	_build_element: (obj) ->
		elem = document.createElement obj.type

		# set class
		if obj.classes != null && obj.classes != undefined
			for arr, index in obj.classes
				elem.className += obj.classes[index] + ' '

		# set attribute
		if obj.attributes != null && obj.attributes != undefined
			for arr, index in obj.attributes
				elem.setAttribute obj.attributes[index][0], obj.attributes[index][1]

		# set innerHTML
		if obj.content != null && obj.content != undefined
			elem.innerHTML = obj.content

		# set inline styles
		if obj.styles != null && obj.styles != undefined
			for arr, index in obj.styles
				elem.style[obj.styles[index][0]] = obj.styles[index][1]

		return elem

	# custom cases
	# 1. default
	_build_default: ->

	# 2. image:
	_build_picture: (pin, index, type) ->
		# build custom tag -- tag: figure -- class: paper-pull--type--[type]--wrap
		# params:
		# 1. tag
		# 2. classes
		# 3. attributes
		# 4. innerContent
		# 5. inline styles
		tag = @_build_element(
					obj = {
						type : 'figure',
						classes : [['paper-pull--type--' + type + '--wrap']]
					}
				)

		console.log(pin)
		return tag

	# 3. image:
	_build_youtube: (pin, index) ->
		tag = ''

		return tag

	#------------------
	# ---- all replace fn
	# -----------------

	#------------------
	# ---- all remove fn
	# -----------------


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
		@_build_structure()
		#@_get_nodeValue(@_get_pins(), 0, 'jjj')

