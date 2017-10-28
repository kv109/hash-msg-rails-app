#= require clipboard.min

$( ->
  clipboard = new Clipboard('[data-clipboard-target]')
  clipboard.on('success', (event) ->
    trigger = $(event.trigger)
    trigger.blur()

    # Clone, remove and re-insert the target element to allow repeat animations
    # per https://css-tricks.com/restart-css-animation
    target = $(trigger.data('clipboard-target'))
    target_clone = target.clone(true) # withDataAndEvents
    target_clone.addClass('clipboard-copy-highlight')
    target.after(target_clone)
    target.remove()
  )
)
