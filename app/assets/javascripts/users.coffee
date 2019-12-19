$ ->
  new AvatarCropper()

class AvatarCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 600, 600]
      onSelect: @update
      onChange: @update
      trueSize: [$('#cropbox').data('real-width'), $('#cropbox').data('real-height')]

  update: (coords) =>
    $('#user_profile_attributes_crop_x').val(coords.x)
    $('#user_profile_attributes_crop_y').val(coords.y)
    $('#user_profile_attributes_crop_w').val(coords.w)
    $('#user_profile_attributes_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#preview').css
      width: Math.round(100/coords.w * $('#cropbox').data('real-width')) + 'px'
      height: Math.round(100/coords.h * $('#cropbox').data('real-height')) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'
