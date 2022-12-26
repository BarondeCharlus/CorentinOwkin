##
# Owkin Test
#
# @file
# @version 0.1
base64:
	@echo "Computing gzip and base64 on Dockerfile..."
	cat Dockerfile | gzip | base64 -w 0

# end
