# RightScale MySQL Database Cookbook

## DESCRIPTION:

Provides the MySQL implementation of the 'db' resource to install and manage
MySQL database stand-alone servers and clients.

## REQUIREMENTS:

* Requires a server launched from a RightScale managed RightImage.

## COOKBOOKS DEPENDENCIES:

Please see `metadata.rb` file for the latest dependencies.

## KNOWN LIMITATIONS:

There are no known limitations.

## SETUP:

* To setup only the database client, place `db::default` recipe into
  your runlist. This will pull in generic client inputs, provide provider
  selection input and install client. Set db/provider_type input in
  RightScale ServerTemplate to set provider and version for 'db' resource.
* To setup a MySQL database client and server, place the following recipes
  in order to your runlist:

    db_mysql::setup_server_<version>
      loads the MySQL provider, tuning parameters, as well as other
      MySQL-specific attributes into the node as inputs.

    db::install_server
      sets up generic server and client inputs. This will also include
      db::default recipe which installs the client.

  For example: To set up and install MySQL 5.5 client and server

    db_mysql::setup_server_5_5
    db::install_server

## USAGE:
