aud = new Audio
aud.autoplay = no
aud.src = '/cheers1.mp3'

max = { x: 0, y: 0, z: 0 }
min = { x: 0, y: 0, z: 0 }

phase = [no, no, no]

lock = no

($ document).on 'click', '#ini', ->
  aud.load()
  aud.pause()
  ($ this).fadeOut 240
     		   
window.addEventListener 'devicemotion', (event) ->
  event.preventDefault()
  ac = event.acceleration

  x = Math.abs ac.x
  y = Math.abs ac.y
  z = Math.abs ac.z

  max.x = ac.x if ac.x > max.x
  max.y = ac.y if ac.y > max.y
  max.z = ac.z if ac.z > max.z

  min.x = ac.x if ac.x < min.x
  min.y = ac.y if ac.y < min.y
  min.z = ac.z if ac.z < min.z

  if ac.x > 50 or ac.x < -50
    ($ "#ac0").css 'color', '#00F'
    aud.load()
    aud.play()
    ($ '#st1').addClass 'on'
    lock = yes
    $.ajax '/push',
    setTimeout ->
     lock = no
    , 1000

  ($ "#ac0").html "X: #{ac.x}<br>#{max.x}<br>#{min.x}"
  ($ "#ac1").html "Y: #{ac.y}<br>#{max.y}<br>#{min.y}"
  ($ "#ac2").html "Z: #{ac.z}<br>#{max.z}<br>#{min.z}"


  # ($ "#ag0").text "X: #{ag.x}"
  # ($ "#ag1").text "Y: #{ag.y}"
  # ($ "#ag2").text "Z: #{ag.z}"

  # ($ "#rt0").text "A: #{rt.alpha}"
  # ($ "#rt1").text "B: #{rt.beta}"
  # ($ "#rt2").text "G: #{rt.gamma}"
