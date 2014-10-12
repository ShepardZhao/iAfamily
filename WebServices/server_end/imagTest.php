<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 9/10/14
 * Time: 5:55 PM
 */

$olad = 'c:\1.jpeg';
$new = 'c:\2.jpeg';
$width='75';
$height='75';

$exec = 'convert '.$olad.' -quality 100 -resize '.$width.'x'.$height.'! '.$new;

echo exec('c:/ImageMagick/convert.exe '.$exec);


