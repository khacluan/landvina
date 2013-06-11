window.RubifyJS =
  
  loadingHTML: "<div class='loading' id='stage_loading'>Loading...</div>"
  
  addRefreshLink: (target, link) ->   
    $("#stage h2:first").append "&nbsp;<a href='#' class='ajax-link reload-head' data-load-element='##{target.attr('id')}' data-url='#{link}'>Refresh</a>" if (RubifyDashboardConfig.show_refresh and target and !RubifyDashboardConfig.use_history)
      
  logHistory: (url, title=$("title").html()) ->
    if RubifyDashboardConfig.use_history
      History = window.History
      return false if !History.enabled
      window.history.ready = true
      History.pushState({isMine: true}, title, url)
  
  popStateCallBack: ->
    if typeof(RubifyDashboardConfig) != "undefined" and RubifyDashboardConfig.use_history
      History = window.History
      return false if !History.enabled
                  
      window.addEventListener 'popstate', (event) ->
        if (!window.history.ready and $.browser.webkit == true)
          window.history.ready = true          
          return
        return if (event.originalEvent and event.originalEvent.state and event.originalEvent.state.type != 'popstate')
        document.location.reload()
        
  loadingHTMLText: ->
    @loadingHTML.replace "Loading", if $("#loading_text").length > 0 then $("#loading_text").html() else "Loading..."

  loadToStage: (url) ->
    $("#stage").html @loadingHTMLText()
    $("#stage_loading").vAlign()
    $("#stage").load url

  loadCallBack: ->
    $(".ajax-form").find("input[type=text]:first, input[type=number]:first").removeAttr "disabled"
    $(".ajax-form").find("input[type=text]:first").focus()
    @callBackAfterIFrameSubmit()
    @formatDatePicker()

  formatDatePicker: ->
    $(".calendar-field").each ->
      startYear = $(this).attr("start_year")
      minDate = null
      minDate = new Date(startYear, 0, 1)  if startYear?
      endYear = $(this).attr("end_year")
      maxDate = null
      maxDate = new Date(endYear, 12, 31)  if endYear?
      $(this).datepicker
        dateFormat: "dd/mm/yy"
        minDate: minDate
        maxDate: maxDate
        buttonImage: "/assets/icons/calendar.gif"
        buttonImageOnly: true
        showOn: "button"

  checkAuthentication: (xhr) ->
    document.location.reload true  if xhr.status is 401

  loadSearchingResponse: (response) ->
    $("#searching_result").html response
    $("#search_button").val($("#search_button").attr("data-after-submit-value")).removeAttr("disabled").removeClass "disabled"

  callBackAfterDownloadFinish: ->
    token = new Date().getTime()
    $("#download_token_value_id").val token
    fileDownloadCheckTimer = window.setInterval(->
      cookieValue = $.cookie("fileDownloadToken")
      if (cookieValue + "") == (token + "")
        (finishDownload = ->
          window.clearInterval fileDownloadCheckTimer
          $.cookie "fileDownloadToken", null #clears this cookie value
          window.parent.$("#submit_button_for_report").removeAttr("disabled").removeClass("disabled").val $("#submit_text").html()
        )()
    , 1000)

  callBackAfterIFrameSubmit: ->
    @scrollTop()
    $("#stage h2:first").append "<div class='back back-link'>" + $("#previous_load").attr("data-back-text") + "</div>"  unless $("#previous_load").html() is ""
    if $("p.inline-errors:first").parents("form:first").hasClass("two-column-form")
      $("p.inline-errors").each( ->
        $(this).attr("title", $(this).html())
        $(this).html("")
      )
    @formatDatePicker()

  scrollTop: ->
    $("#stage").scrollTop 0
    $("#inner_layout_column").scrollTop 0

  remove_fields: (link) ->
    $(link).prev("input[type=hidden]").val "1"
    $(link).closest(".fields").hide()

  add_fields: (link, association, content) ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_" + association, "g")
    $(link).parent().before content.replace(regexp, new_id)
  
  add_table_fields: (link, association, content) ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_" + association, "g")
    if $(link).parents("tr:first").length > 0
      $(link).parents("tr:first").before content.replace(regexp, new_id)
      counter = 0
      $(link).parents("tbody:first").find("tr").each( ->
        $(this).removeClass("odd even").addClass(if counter % 2 == 0 then "even" else "odd")
        counter = counter + 1
      )
      if $(link).attr("data-max-entry") and parseInt($(link).attr("data-max-entry"), 10) != -1
        $(link).addClass("hidden") if counter >= parseInt($(link).attr("data-max-entry"), 10)
      else
        $(link).removeClass("hidden")
    else
      $(link).before $(content.replace(regexp, new_id)).addClass("table-model-field")
      elements_count = $(link).parents().children().length - 1
      if $(link).attr("data-max-entry") and parseInt($(link).attr("data-max-entry"), 10) != -1
        $(link).addClass("hidden") if elements_count >= parseInt($(link).attr("data-max-entry"), 10)
      else
        $(link).removeClass("hidden")  
      
  loadUrlTo: (link, container) ->
    $(container).html @loadingHTMLText()
    $("#stage_loading").vAlign()
    $(container).load link

  reloadEmployee: (employeeId, fn) ->
    $("#previous_load").find("div[employee_id=" + employeeId + "]").parent().load "/users/" + employeeId + "/search_detail", ->
      fn()
      document.getElementById("employee_id_" + employeeId).scrollIntoView()
      $("#previous_load").html ""

  createHiddenIframe: ->
    $('body').append "<iframe name='rubify_js_hidden_iframe' id='rubify_js_hidden_iframe'></iframe>"
  
  createHiddenDivForBackContent: ->
    $('body').append "<div class='hidden' id='previous_load'></div>"
      
  renderLayout: (loadElement) ->
    if loadElement.find("div.ui-layout-center").length > 0
      loadElement.find("div.ui-layout-center").each( ->        
        parentElement = $(@).parent()
        innerLayout = parentElement.layout(
          spacing_closed: 0
          spacing_open: 0
        )
        
        westColumn = parentElement.find("> div.ui-layout-west:first")
        innerLayout.sizePane "west", westColumn.attr("data-width") if westColumn.length > 0 and westColumn.attr("data-width")
        
        eastColumn = parentElement.find("> div.ui-layout-east:first")
        innerLayout.sizePane "eastColumn", eastColumn.attr("data-width") if eastColumn.length > 0 and eastColumn.attr("data-width")
        
        southColumn = parentElement.find("> div.ui-layout-south:first")
        innerLayout.sizePane "south", southColumn.attr("data-height") if southColumn.length > 0 and southColumn.attr("data-height")
        
        northColumn = parentElement.find("> div.ui-layout-north:first")
        innerLayout.sizePane "north", northColumn.attr("data-height") if northColumn.length > 0 and northColumn.attr("data-height")
      )
      
  initialize: ->
    $ ->
      $("input[type=submit]").removeAttr("disabled")
      RubifyJS.createHiddenDivForBackContent()
      RubifyJS.createHiddenIframe()
      RubifyJS.renderLayout($("body"))
      $(document.body).tipsy({delegate: 'p.inline-errors', fade: true});      
      $(document.body).delegate "div.sidebar ul.tree li, div.sidebar > div.drop-in-menu > div.content > div.menu-leaf", "click", (event) ->
        sideBarDiv = $(this).parents("div.drop-in-menu:first")
        $("#previous_load").html ""  if sideBarDiv.hasClass("main-menu") is true
        aTag = $(this).find("a:first")
        link = aTag.attr("href")
        target = $("#stage")
        target = $(aTag.attr("data-target"))  if aTag.attr("data-target")          
        target.loadHtmlAndClearLayout RubifyJS.loadingHTMLText()
        $("#stage_loading").vAlign()
        
        target.load link, (response, status, xhr) ->
          RubifyJS.loadCallBack()
          if $("#previous_load").html() isnt "" and $(target).find("h2:first div.back").length is 0 and sideBarDiv.hasClass("main-side-bar") is false
            $(target).find("h2:first").append "<div class='back back-link'>#{$("#previous_load").attr("data-back-text")}</div>"            
          RubifyJS.checkAuthentication xhr          
          RubifyJS.renderLayout($(".ui-layout-center:first"))
          RubifyJS.addRefreshLink(target, link)
          RubifyJS.logHistory(link, aTag.html())
               
        sideBarDiv.find("ul.tree li, div").removeClass "active"
        $(this).addClass "active"
        false
      
      $(document.body).delegate "div.ui-layout-north ul.tree li, div.ui-layout-north > div.drop-in-menu > div.content > div.menu-leaf", "click", (event) ->
        sideBarDiv = $(this).parents("div.drop-in-menu:first")
        $("#previous_load").html ""  if sideBarDiv.hasClass("main-menu") is true
        sideBarDiv.find("h3, div.menu-leaf, li.active").removeClass("active")
        (h3Element = $(this).parents("h3:first")).addClass('active no-hover')
        aTag = $(this).find("a:first")
        link = aTag.attr("href")
        target = $("#stage")
        target = $(aTag.attr("data-target"))  if aTag.attr("data-target")          
        target.loadHtmlAndClearLayout RubifyJS.loadingHTMLText()
        $("#stage_loading").vAlign()
        
        target.load link, (response, status, xhr) ->
          RubifyJS.loadCallBack()
          if $("#previous_load").html() isnt "" and $(target).find("h2:first div.back").length is 0 and sideBarDiv.hasClass("main-side-bar") is false
            $(target).find("h2:first").append "<div class='back back-link'>#{$("#previous_load").attr("data-back-text")}</div>"  
          h3Element.removeClass("no-hover")
          RubifyJS.checkAuthentication xhr          
          RubifyJS.renderLayout($(".ui-layout-center:first"))
          RubifyJS.addRefreshLink(target, link)
          RubifyJS.logHistory(link, aTag.html())
          
      
        sideBarDiv.find("ul.tree li").removeClass "active"
        $(this).addClass "active"
        false
      
      $(document.body).delegate "input.resource-search", "keyup", (event) ->
        clearTimeout window.typingTimer
        if event.keyCode == 13
          window.oTable.fnFilter $(@).val()
          return
          
        self = $(@)
        if self.val().length > 0
          $(".search-cross-icon").fadeIn()          
        else
          $(".search-cross-icon").fadeOut()
          
        window.typingTimer = window.setTimeout ->
          value = self.val()
          window.oTable.fnFilter value
        , 1000
      
      $(document.body).delegate "div.search-cross-icon", "click", ->
        $("input.resource-search").val("").focus()
        oTable.fnFilter ""
        $(".search-cross-icon").fadeOut()
              
      $(document.body).delegate "form.ajax-form", "submit", ->
        $(".info").remove()
        $("#errorExplanation").remove()
        if $(this).attr("data-should-store-for-back") is "yes"
          $("#previous_load").html $("#stage").html()
          $("#previous_load").attr "data-back-text", $(this).attr("data-back-text")
          $("#previous_load").attr "data-callback-fn", $(this).attr("data-callback-fn")
          $("#previous_load").attr "data-current-url", document.location.href
        submitButton = $(this).find("input[type=submit]")
        submitButton.addClass("disabled").attr "disabled", "disabled"
        if $(this).attr("method") == "get"
          RubifyJS.logHistory($(this).attr("action") + "?" + $(this).serialize().replace("&_iframe=true", ""))
          
        unless typeof (submitButton.attr("data-submit-value")) is "undefined"
          submitButton.val submitButton.attr("data-submit-value")
        else
          submitButton.val (if $("#saving_text").length > 0 then $("#saving_text").html() else "Saving...")

      $(document.body).delegate ".pagination a", "click", (event) ->
        container = $("#stage")
        container = $("#searching_result")  if $(this).parents("div#searching_result:first").length > 0
        container.loadHtmlAndClearLayout RubifyJS.loadingHTMLText()
        $("#stage_loading").vAlign()
        container.load $(this).attr("href"), (response, status, xhr) ->
          $(".pagination span.current").html $.trim($(".pagination span.current").html())
          RubifyJS.checkAuthentication xhr
          RubifyJS.renderLayout(container)
        false
      
      $(document.body).delegate ".back-link", "click", (event) ->
        callBackFn = $("#previous_load").attr("data-callback-fn")
        if typeof (callBackFn) isnt "undefined" and callBackFn? and callBackFn isnt ""
          newCallBackFn = callBackFn.replace("function() {}", "function() { $(\"#stage\").loadHtmlAndClearLayout($(\"#previous_load\").html());$(\"#previous_load\").html(\"\");}")
          eval(newCallBackFn)
          RubifyJS.logHistory($("#previous_load").attr("data-current-url"))
        else
          $("#stage").loadHtmlAndClearLayout $("#previous_load").html()
          $("#previous_load").html ""         
          RubifyJS.logHistory($("#previous_load").attr("data-current-url"))
          
        $(".ajax-form").find("input[type=text]:first").focus()

      $(document.body).delegate ".ajax-link", "click", (event) ->
        if $(this).hasClass("reload-head")
          window.reloadingHead = true
          $(document.head).load("/head_content")
          
        dataConfirm = $(this).attr("data-confirm")
        if dataConfirm
          confirm = window.confirm($(this).attr("data-confirm"))
          return false  if confirm is false
        dataShouldStoreForBack = $(this).attr("data-should-store-for-back")
        if dataShouldStoreForBack is "yes"
          $("#previous_load").html $("#stage").html()
          $("#previous_load").attr "data-back-text", $(this).attr("data-back-text")
          $("#previous_load").attr "data-callback-fn", $(this).attr("data-callback-fn")
          $("#previous_load").attr "data-current-url", document.location.href
        self = this
        $(this).addClass("inactive-link").html $(this).attr("data-onload")  if $(this).attr("data-onload")
        url = $(this).attr("data-url")
        url = $(this).attr("href") if typeof(url) is "undefined"
        aTagContent = $(this).html()
        if $(this).attr("data-load-element")
          $($(this).attr("data-load-element")).loadHtmlAndClearLayout RubifyJS.loadingHTMLText()
          $("#stage_loading").vAlign()

        data_method = $(this).attr("data-method") 
        $.ajax
          url: url
          type: (if data_method then data_method else "GET")
          error: (xhr) ->
            RubifyJS.checkAuthentication xhr
          success: (response, status, xhr) ->
            if data_method and data_method.toUpperCase() == "DELETE" and response == "restriction"
              $(self).html($("#rubify_dashboard_remove_text").html()).removeClass("inactive-link")
              alert $("#rubify_dashboard_this_record_cannot_be_deleted_because_it_is_currently_linked_by_some_other_record").html()
            else  
              if $(self).attr("data-reload-element")
                reloadElement = $(self).attr("data-reload-element")
                $(reloadElement).selfLoad()
              if $(self).attr("data-load-element")
                loadElement = $($(self).attr("data-load-element"))
                loadElement.html response
                RubifyJS.renderLayout(loadElement)
                window.setTimeout (->
                  $($(self).attr("data-load-element")).scrollTop 0
                ), 100
              
                if $("#previous_load").html() isnt "" and $("#stage h2:first div.back").length is 0
                  $("#stage h2:first").append "<div class='back back-link'>#{$("#previous_load").attr("data-back-text")}</div>"  
            
              RubifyJS.addRefreshLink(loadElement, url)
              eval($(self).attr("data-on-finish")) if $(self).attr("data-on-finish")
              $(".ajax-form").find("input[type=text]:first, input[type=number]:first").removeAttr("disabled").focus()
              $("#barcode_input").focus()
              RubifyJS.formatDatePicker()
              eval($(self).attr("data-callback")) if $(self).attr("data-callback")
              RubifyJS.logHistory(url, aTagContent)           
        false

      $(document.body).delegate ".minus-button", "click", ->
        $(this).parents(".compact:first").find(".destroy-input").attr("value", "true")
        $(this).parents(".compact:first").fadeOut()

      $(document.body).delegate ".table-minus-button", "click", ->
        $(this).parents("tr:first").find(".destroy-input").val("true")
        $(this).parents("tr:first").fadeOut( ->
          counter = 0
          $(this).parents("tbody:first").find("tr").each( ->            
            if $(this).css('display') isnt 'none'
              $(this).removeClass("odd").removeClass("even").addClass(if counter % 2 == 0 then "even" else "odd")
              counter = counter + 1
          )
        )
        
      $(document.body).delegate "a.normal-entry-delete", "click", ->
        if $(@).hasClass("at-least-one-entry")
          parentDiv = $(@).parents("div.fields")
          counter = 0
          parentDiv.children().each ->
            counter += 1 if $(@).is("fieldset") and $(@).hasClass("hidden") is false
          if counter == 1
            alert $(@).attr("data-one-entry-message")
            return false
        $(@).parent().find("input.destroy-input:first").attr("checked", "checked").val("true")
        if $(@).parents("tr:first").length > 0
          $(@).parents("tr:first").fadeOut( -> 
            $(@).addClass("hidden")
          )
        else
          $(@).parents("fieldset:first").fadeOut( -> 
            $(@).addClass("hidden")
          )
        eval($(@).attr("data-callback-js")) if $(@).attr("data-callback-js")          
        false
        
      $(document.body).delegate "select.chain-load", "change", ->
        url = $(@).attr("data-load-url")
        loadOrders = $(@).attr("data-load-order").split(",")
        domId = $(@).attr("id").replace(loadOrders[0], loadOrders[1])
        if loadOrders[2]
          secondLevelDomId = $(@).attr("id").replace(loadOrders[0], loadOrders[2])
        else
          secondLevelDomId = ""
          
        targetDomName = $("##{domId}").attr("name")
        $("##{domId}").replaceWith "<div id='#{domId}_container'>#{$("#please_wait_text").html()}</div>"
        $("##{domId}_container").load "#{url}?parent_id=#{$(@).val()}&target_dom_id=#{domId}&target_dom_name=#{targetDomName}&second_level_dom_id=#{secondLevelDomId}&loadOrders=#{$(@).attr("data-load-order").replace(loadOrders[0] + ',', '')}"

      $(document.body).delegate "form.enter-key-form input, form.enter-key-form select, form.enter-key-form textarea", "keydown", (event) ->
        if event.keyCode is 13 and $(this).attr("type") isnt "submit"
          nextElement = $(this).parents("li:first").next()
          if nextElement.hasClass("legend")
            nextElement = nextElement.next()
          else nextElement = $(this).parents("li.input:first").next()  if nextElement.length is 0
          nextElement = $(this).parents("fieldset.inputs:first").parents("li.input:first").next()  if nextElement.length is 0
          nextElement = $(this).parents("form:first").find("input[type=submit]").focus()  if nextElement.length is 0
          nextElement.find("input[type!=hidden]:first,select:first,textarea:first")[0].focus()
          false

      $(document.body).delegate "h3.subtitle", "mouseover", (e) ->
        $(this).find("span.show-hide").removeClass "hidden" if $(e.target).parents("ul.tree:first").length == 0
        
      $(document.body).delegate "span.show-hide", "click", ->
        self = this
        $(this).parent().find("ul.tree").toggle "hidden", ->
          if $(self).parent().find("ul.tree").css("display") is "none"
            $(self).html(if $("#rubify_dashboard_show_text").length > 0 then $("#rubify_dashboard_show_text").html() else "Show")
          else
            $(self).html(if $("#rubify_dashboard_hide_text").length > 0 then $("#rubify_dashboard_hide_text").html() else "Hide")


      $(document.body).delegate "h3.subtitle", "mouseout", ->
        $(this).find("span.show-hide").addClass "hidden"

      $(document.body).delegate "div.function-button", "click", ->
        url = $(this).attr("data-url")
        content_text = $(this).text()       
        if url and $(this).hasClass("disabled") is false          
          # $("#inner_layout_column").css opacity: 0.5        
          $("#inner_layout_column").loadHtmlAndClearLayout RubifyJS.loadingHTMLText()
          $("#stage_loading").vAlign()
          $("#inner_layout_column").load url, ->
            # $("#inner_layout_column").css opacity: 1
            RubifyJS.renderLayout($("#inner_layout_column"))
            RubifyJS.logHistory(url, content_text)


      $(document.body).delegate "table.item-list tr", "click", ->
        $("table.item-list tr").removeClass "clicked"
        $(this).addClass "clicked"
        unless typeof ($(this).attr("data-url")) is "undefined"         
          table = $(this).parents("table")
          dataUrl = $(this).attr("data-url")
          $(this).parents("div.content").animate
            left: -($(table).width() + 50)
            opacity: 0
          , 500, ->
            $("#stage").html RubifyJS.loadingHTMLText()
            $("#stage_loading").vAlign()
            $("#stage").load dataUrl
      
      
      RubifyJS.popStateCallBack()
      $(document.body).delegate ".modal-box-link", "click", (event) ->
        dataReloadElement = $(this).attr("data-reload-element")
        dataCallBackFn = $(this).attr("data-callback-fn")
        dataCallBackFn = "(function() {})" if typeof(dataCallBackFn) is "undefined"
        if onCompleteFnStr = $(@).attr("data-on-complete")
          onCompleteFn = ->
            eval "#{onCompleteFnStr}();"
        else
          onCompleteFn = ->
            focusElement = null
            (focusElement = $("#fancybox-content input[type=text]:first")).focus()  if $("#fancybox-content input[type=text]:first").length > 0
            $("#fancybox-content textarea:first").focus()  if $("#fancybox-content textarea:first").length > 0 if focusElement is null || focusElement.length == 0            
            form = $("#fancybox-content form:first")
            form.ajaxForm
              beforeSubmit: (arr, form, options)->
                submitButton = $(form).find("input[type=submit]")
                if typeof(submitButton.attr("data-saving-display")) != "undefined"
                  saving_text = submitButton.attr("data-saving-display")
                else
                  saving_text = if $("#saving_text").length > 0 then $("#saving_text").html() else "Saving..."
                submitButton.val(saving_text).attr("disabled", "disabled").addClass "disabled"
              success: (response) ->
                if response is "successful"
                  $.fancybox.close()
                  $(dataReloadElement).selfLoad()
                  eval(dataCallBackFn).call()
                else if response is "refresh"
                  window.location.reload()
                else
                  $("#fancybox-content").html response
                  $("#fancybox-content").find("li.error input:first").focus()
                  onCompleteFn()
            
            form.find("a.cancel").click ->
              $.fancybox.close()
              false

        defaultFancyBoxOpt =
          href: $(this).attr("data-url")
          overlayOpacity: 0.5
          padding: 0
          modal: true
          onComplete: onCompleteFn

        if typeof(RubifyDashboardModalBoxConfig) isnt "undefined" 
          inputFancyBoxOpt = RubifyDashboardModalBoxConfig
        else
          inputFancyBoxOpt = {}

        $.fancybox $.extend({}, defaultFancyBoxOpt, inputFancyBoxOpt)        
        false

(($) ->
  $.fn.vAlign = (offset) ->
    offset = 0  if typeof (offset) is "undefined"
    @each (i) ->
      ah = $(this).height()
      ph = (if $(document.body).find("#user_new_container").length == 0 then $(this).parent().height() else $(window).height())
      mh = Math.ceil((ph - ah) / 2)
      $(this).css "margin-top", mh - offset
  
  ## Usage
  ## Assuming that /items url returns the content as table
  ##    <table>...</table>
  ##
  ## Then we can write the following HTML code    
  ##
  ## <div id='to_reload_content' data-url='/items/'>
  ##    <table>...</table>
  ## </div>
  ##
  ## And Trigger Javascript
  ## $("#to_reload_content").selfLoad()
  ##
  $.fn.selfLoad = ->
    @each (i) ->
      el = $(@)
      elId = el.attr("id")
      elClass = el.attr("class")
      parent = el.parent()
      
      if url = el.attr("data-url")        
        el.html RubifyJS.loadingHTMLText()
        
        # RubifyJS.renderLayout(parent)

        $("#stage_loading").vAlign()
        $.get url, (response) ->
          $("<div id='rubify_dashboard_self_load_element'>" + response + "</div>").appendTo(parent)
          wrapper = $("#rubify_dashboard_self_load_element")
          window.test = wrapper
          if elId
            toChangeElement = wrapper.find("#" + elId)
          else
            elClass = $.trim(elClass.replace(/ui-layout-[-|\w]*/g, ""))
            toChangeElement = wrapper.find("*[class*='" + elClass + "']")
          el.data("layout").destroy() if el.data("layout")
          parent.data("layout").destroy() if parent.data("layout")
          el.replaceWith(toChangeElement)
          wrapper.remove()
          RubifyJS.renderLayout(parent)
          
  ## Deprecated
  $.fn.reloadContent = ->
    @each (i) ->
      if $(this).attr("data-url")
        url = $(this).attr("data-url")
        loadElement = $(this).parents("div.ui-layout-center:first").parent()
        loadElement.loadHtmlAndClearLayout RubifyJS.loadingHTMLText()
        $("#stage_loading").vAlign()
        loadElement.load url, ->
          RubifyJS.renderLayout(loadElement)
  
  $.fn.loadHtmlAndClearLayout = (htmlContent) ->
    if $(@).data('layout')
      $(@).data('layout').destroy()     
    $(@).html htmlContent
    RubifyJS.renderLayout($(@))
) jQuery

window.RubifyJS.initialize() if window.reloadingHead != true