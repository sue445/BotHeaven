class BotHeaven.Bots.Editor
  # Elements
  elements:
    navbar:   '.js-navbar'
    editor:   '.js-editor'
    textarea: '.js-textarea'
    toolbar:  '.js-toolbar'
    switcher: '.js-switcher'


  # Initialize
  # @param [Boolean] editable true if Editable.
  constructor: (@editable) ->
    @fetchElements()
    @initializeCodeMirror()
    @assignEvents()


  # Fetch elements
  fetchElements: ->
    @$elements = new Object()
    for key, value of @elements
      @$elements[key] = $(value)

  # Initialize CodeMirror
  initializeCodeMirror: ->
    @codeMirror = CodeMirror.fromTextArea(@$elements.textarea[0], {
      mode:        'javascript',
      lineNumbers: true,
      readOnly:    !@editable
    })
    @isFullscreen = false

  # Assign Events
  assignEvents: ->
    $(window).bind 'resize', @onSizeChanged.bind(@)
    @$elements.switcher.bind 'click', @onSwitch.bind(@)

  # Toggle Screen mode event.
  onSwitch: ->
    icon = @$elements.switcher.find('.glyphicon')
    @isFullscreen = !@isFullscreen
    if @isFullscreen
      icon.removeClass('glyphicon-resize-full')
      icon.addClass('glyphicon-resize-small')
      @$elements.editor.find('.CodeMirror').css(position: 'fixed', top: @$elements.navbar.height(), left: 0)
      @$elements.toolbar.css(position: 'fixed', bottom: 0, left: 0)
      @onSizeChanged()
      @codeMirror.refresh()
    else
      icon.removeClass('glyphicon-resize-small')
      icon.addClass('glyphicon-resize-full')
      @$elements.editor.find('.CodeMirror').css(width: '100%', height: 'auto', position: 'relative', top: 0, left: 0)
      @$elements.toolbar.css(width: '100%', position: 'relative')
      @codeMirror.refresh()

  # Window Size Change event.
  onSizeChanged: ->
    return unless @isFullscreen
    width = $(document).width()
    height = $(document).height() - @$elements.navbar.height() - @$elements.toolbar.height()
    @$elements.editor.find('.CodeMirror').css(width: width, height: height)
    @$elements.toolbar.css(width: width)
