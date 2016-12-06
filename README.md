# CaaS or Computer as a Service

CaaS is a docker platform that lets you use a containerized computer with a desktop environmen using a vnc client or simply in your webbrower.

## Preview (completely unfinished)
![Website](https://raw.githubusercontent.com/BartWillems/CaaS/master/caas.png)

## Getting Started

To begin using CaaS you should 
* Install docker
* Install a LAMP stack
* clone [this](https://github.com/BartWillems/CaaS) repo (git clone https://github.com/BartWillems/CaaS) and run install.sh
* copy the html folder to a chosen location (eg /var/www/html)

The website makes use of mod_rewrite and mod_proxy through a .htaccess file.
In order to make these work you should install and enable these modules and also allow 'AllowOverride' on your website folder in your apache config.

The docker containers use port mappings to connect to the host. I use the htaccess file to make sure that only requests for a certain port range are allowed.
You MUST set your own port range in both the website AND the htaccess file for your own security. 
All of your ports from within your chosen port range should be available and within 1024-9999.

Example config: 
`RewriteRule '^computers/(700[0-9])/(.*)' 'http://127.0.0.1:$1/$2' [L,P]`
This allows containers to be made in the range of 7000-7009


## Bugs and Issues

Have a bug or an issue? [Open a new issue](https://github.com/BartWillems/CaaS/issues) here on GitHub.

Please note that CaaS is currently only supported on Ubuntu.

## Creator

CaaS was/is being created by Bart Willems, your favorite free and open source software developer.

## Copyright and License

CaaS uses the GNU General Public License V3 which respects your basic 4 freedoms:
* The freedom to run the program as you wish, for any purpose (freedom 0).
* The freedom to study how the program works, and change it so it does your computing as you wish (freedom 1). Access to the source code is a precondition for this.
* The freedom to redistribute copies so you can help your neighbor (freedom 2).
* The freedom to distribute copies of your modified versions to others (freedom 3). By doing this you can give the whole community a chance to benefit from your changes. Access to the source code is a precondition for this.
