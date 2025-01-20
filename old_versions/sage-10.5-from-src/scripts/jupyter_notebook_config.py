## The IP address the notebook server will listen on.
c.NotebookApp.ip = '0.0.0.0'

## Set the log level by value or name.
c.Application.log_level = 'CRITICAL'

## Whether to open in a browser after starting. The specific browser used is
#  platform dependent and determined by the python standard library `webbrowser`
#  module, unless it is overridden using the --browser (ServerApp.browser)
#  configuration option.
c.NotebookApp.open_browser = False

## Token used for authenticating first-time connections to the server.
#  
#  When no password is enabled, the default is to generate a new, random token.
#  
#  Setting to an empty string disables authentication altogether, which is NOT
#  RECOMMENDED.
c.NotebookApp.token = ''

## Disable cross-site-request-forgery protection
#  
#  Jupyter notebook 4.3.1 introduces protection from cross-site request
#  forgeries, requiring API requests to either:
#  
#  - originate from pages served by this server (validated with XSRF cookie and
#  token), or - authenticate with a token
#  
#  Some anonymous compute resources still desire the ability to run code,
#  completely without authentication. These services can disable all
#  authentication and security checks, with the full knowledge of what that
#  implies.
c.NotebookApp.disable_check_xsrf = True


## The kernel manager class to use.
#  cf https://github.com/jupyter/notebook/issues/6164
c.NotebookApp.kernel_manager_class = 'notebook.services.kernels.kernelmanager.AsyncMappingKernelManager'
