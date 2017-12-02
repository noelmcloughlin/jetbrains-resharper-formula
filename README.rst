========
jetbrains resharper
========

Formula for latest ReSharper IDE from Jetbrains on Windows.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    Refer to pillar.example and defaults.yaml for configurable values. To be verified on Windows
    
Available states
================

.. contents::
    :local:

``resharper``
------------

Downloads the archive from Jetbrains website, unpacks locally and installs the IDE on the Operating System.

.. note::

This formula automatically installs latest Jetbrains release. This behaviour may be overridden in pillars.

``resharper.developer``
------------
Create Desktop shortcuts. Optionally get preferences file from url/share and save into 'user' (pillar) home directory.

