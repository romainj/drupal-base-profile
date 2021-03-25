<?php

/**
 * @file
 * Enables modules and site configuration for a base site installation.
 */

use Drupal\contact\Entity\ContactForm;
use Drupal\Core\Form\FormStateInterface;

/**
 * Implements hook_form_FORM_ID_alter() for install_configure_form().
 *
 * Allows the profile to alter the site configuration form.
 */
function base_form_install_configure_form_alter(&$form, FormStateInterface $form_state) {
  $form['regional_settings']['site_default_country']['#default_value'] = 'FR';
  $form['regional_settings']['date_default_timezone']['#default_value'] = 'Europe/Paris';
  $form['#submit'][] = 'base_form_install_configure_submit';
}

/**
 * Submission handler to sync the contact.form.feedback recipient.
 */
function base_form_install_configure_submit($form, FormStateInterface $form_state) {
  $site_mail = $form_state->getValue('site_mail');
  ContactForm::load('feedback')->setRecipients([$site_mail])->trustData()->save();
  \Drupal::service('module_installer')->uninstall(['update']);
}
