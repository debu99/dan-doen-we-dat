<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Album
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: editphotos.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     Sami
 */
?>
<?php
  if (APPLICATION_ENV == 'production')
    $this->headScript()
      ->appendFile($this->layout()->staticBaseUrl . 'externals/autocompleter/Autocompleter.min.js');
  else
    $this->headScript()
      ->appendFile($this->layout()->staticBaseUrl . 'externals/autocompleter/Observer.js')
      ->appendFile($this->layout()->staticBaseUrl . 'externals/autocompleter/Autocompleter.js')
      ->appendFile($this->layout()->staticBaseUrl . 'externals/autocompleter/Autocompleter.Local.js')
      ->appendFile($this->layout()->staticBaseUrl . 'externals/autocompleter/Autocompleter.Request.js');
?>

<script type="text/javascript">
  var attachAutoSuggest = function (tagId) {
    en4.core.runonce.add (function() {
      new Autocompleter.Request.JSON(tagId, '<?php echo $this->url(array('controller' => 'tag', 'action' => 'suggest'), 'default', true) ?>', {
        'postVar' : 'text',

        'minLength': 1,
        'selectMode': 'pick',
        'autocompleteType': 'tag',
        'className': 'tag-autosuggest',
        'filterSubset' : true,
        'multiple' : true,
        'injectChoice': function(token){
          var choice = new Element('li', {'class': 'autocompleter-choices', 'value':token.label, 'id':token.id});
          new Element('div', {'html': this.markQueryValue(token.label),'class': 'autocompleter-choice'}).inject(choice);
          choice.inputValue = token;
          this.addChoiceEvents(choice).inject(this.choices);
          choice.store('autocompleteChoice', token);
        }
      });
    });
  }
</script>
<div class="layout_middle headline">
  <div class="generic_layout_container">
  <h2>
    <?php echo $this->translate('Photo Albums');?>
  </h2>
  <div class="tabs">
    <?php
      // Render the menu
      echo $this->navigation()
        ->menu()
        ->setContainer($this->navigation)
        ->render();
    ?>
  </div>
  </div>
</div>
<div class="layout_middle">
  <div class="generic_layout_container">
    <h3>
      <?php echo $this->htmlLink($this->album->getHref(), $this->album->getTitle()) ?>
      (<?php echo $this->translate(array('%s photo', '%s photos', $this->album->count()),$this->locale()->toNumber($this->album->count())) ?>)
    </h3>
<?php if( $this->paginator->count() > 0 ): ?>
  <br />
  <?php echo $this->paginationControl($this->paginator); ?>
<?php endif; ?>


<form action="<?php echo $this->escape($this->form->getAction()) ?>" method="<?php echo $this->escape($this->form->getMethod()) ?>">
  <?php echo $this->form->album_id; ?>
  <ul class='albums_editphotos'>
    <?php foreach( $this->paginator as $photo ): ?>
      <li>
        <div class="albums_editphotos_photo">
          <?php echo $this->htmlLink($photo->getHref(), $this->itemPhoto($photo, 'thumb.normal'))  ?>
        </div>
        <div class="albums_editphotos_info">
          <?php
            $key = $photo->getGuid();
            echo $this->form->getSubForm($key)->render($this);
          ?>
          <div class="albums_editphotos_cover">
            <input type="radio" name="cover" value="<?php echo $photo->getIdentity() ?>" <?php if( $this->album->photo_id == $photo->getIdentity() ): ?> checked="checked"<?php endif; ?> />
          </div>
          <div class="albums_editphotos_label">
            <label><?php echo $this->translate('Album Cover');?></label>
        </div>
        </div>
      </li>
      <script type="text/javascript">
        attachAutoSuggest('<?php echo $key . '-tags'; ?>');
      </script>
    <?php endforeach; ?>
  </ul>
  
  <?php echo $this->form->submit->render(); ?>
</form>
  </div>
<?php if( $this->paginator->count() > 0 ): ?>
  <br />
  <?php echo $this->paginationControl($this->paginator); ?>
<?php endif; ?>
</div>