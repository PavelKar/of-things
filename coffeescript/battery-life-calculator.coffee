# CalcBatteryLife
class CalcBatteryLife
  @getValues: ->
    @timerunvalue = parseFloat($("#timerun").val().replace(/\,/g,'.'))
    @timesleepvalue = parseFloat($("#timesleep").val().replace(/\,/g, '.'))
    @consumpactivevalue = parseFloat($("#consumpactive").val().replace(/\,/g, '.'))
    @consumpsleepvalue = parseFloat($("#consumpsleep").val().replace(/\,/g, '.'))
    @powerlipobruvalue = parseFloat($("#powerlipobru").val().replace(/\,/g, '.'))
    @powerliposafevalue = parseFloat($("#powerliposafe").val().replace(/\,/g, '.'))
    @unitconsumpsleep = parseFloat($("#unitconsumpsleep").attr('data-unit'))
    return "Values complete"
  @roundoff: (x) ->
    return Math.round(x * 100.0) / 100.0
  @calcpowerlipo: (x, y) ->
    return parseFloat(x * (100 - y) / 100)
  @calcruns: (x, y) ->
    return parseFloat(60 / (x + y));
  @calcrunshour: (x, y) ->
    return parseFloat(3600 / (x + y))
  @calcpowerrun: (x, y) ->
    return parseFloat(x / (x + y) * 3600)
  @calcpowersleep: (x, y) ->
   return parseFloat(y / (x + y) * 3600)
  @calcpowerest: (a, b, c, d) ->
   return parseFloat(a / 3600 * b + c / 3600 * d)
  @sleepconsump: ->
   return parseFloat(@consumpsleepvalue * @unitconsumpsleep)
  @powerlipo: ->
    return @calcpowerlipo(@powerlipobruvalue, @powerliposafevalue)
  @runs: ->
    return @calcruns(@timerunvalue, @timesleepvalue)
  @runshour: ->
    return @calcrunshour(@timerunvalue, @timesleepvalue)
  @powerrun: ->
    return @calcpowerrun(@timerunvalue, @timesleepvalue)
  @powersleep: ->
    return @calcpowersleep(@timerunvalue, @timesleepvalue)
  @powerest: ->
    return @calcpowerest(@powerrun(), @consumpactivevalue, @powersleep(), @sleepconsump())
  @runtimehoursest: ->
    return parseInt(@powerlipo() / @powerest())
  @runtimedaysest: ->
    return parseInt(@runtimehoursest() / 24)
  @runtimedayshoursest: ->
    return parseInt(@runtimehoursest() % 24);
  @dothemath = ->
    if $("#timerun").val() && $("#timesleep").val() && $("#consumpactive").val() && $("#consumpsleep").val() && $("#powerlipobru").val() && $("#powerliposafe").val()
      @getValues()
      # console.log(@getValues())
      $("#solutions").fadeIn()
      if (@runtimehoursest() > 48)
        $(".runtimedaysest").html(@runtimedaysest().toString() + " days and " + @runtimedayshoursest().toString() + " hours")
      if (@runtimehoursest() < 24)
        $(".runtimedaysest").html("less than a day");
      if ((@runtimehoursest() > 24) && (@runtimehoursest() < 48))
        $(".runtimedaysest").html("between one and two days")
      $(".runtimehoursest").html(@runtimehoursest().toString() + " hours")
      $(".powerest").html(@roundoff(@powerest()).toString() + " mAh")
    else
      $("#solutions").fadeOut()

### the jQuery Part ###
# enable consumption unit switching
$("#unitconsumpsleep").click ->
  switch (@.getAttribute('data-unit'))
    when "1.0"
      @.setAttribute('data-unit', "0.001")
      @.innerHTML = "&micro;A"
      console.log @.getAttribute('data-unit')
    when "0.001"
      @.setAttribute('data-unit', "1.0")
      @.innerHTML = "mA"
      console.log @.getAttribute('data-unit')
  CalcBatteryLife.dothemath()
  return
# calculate the results with every user interaction
$("form").keyup ->
  CalcBatteryLife.dothemath()
$("form").keydown ->
  CalcBatteryLife.dothemath()


### Window instantiation ###
CalcBatteryLife.dothemath()
