## A pair of functions that cache the inverse of a matrix.
## Usage Hinv<-cacheSolve(makeCacheMatrix(H)) where H is invertible matrix
## This function creates a special "matrix" object that can cache its inverse in steps:
## set the value of the matrix, get the value of the matrix
## set the value of the inverse, get the value of the inverse

makeCacheMatrix <- function(x = matrix()) {
		k <- NULL
		#assign a value to an object in an environment that is different from the current environment.
	    set <- function(y) {
	    		x <<- y
	        	k <<- NULL
	    }
	    get <- function() x
	    setsolve <- function(solve) k <<- solve
	    getsolve <- function() k
	    list(set = set, get = get,
	         setsolve = setsolve,
	         getsolve = getsolve)
}


## This function computes the inverse of the special "matrix" returned by makeCacheMatrix above. 
## If the inverse has already been calculated (and the matrix has not changed), then the cachesolve should retrieve the inverse from the cache.

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
        k <- x$getsolve()
	    if(!is.null(k)) {
	        	message("Reading cached data")
	        	return(k)
	    }
	    data <- x$get()
	    k <- solve(data, ...)
	    x$setsolve(k)
	    k
}



