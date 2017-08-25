#
# Curl Get Config
#
# IF we are using a system that supports curl-config use it.
#

IF(CURL_FOUND)
    #IF(UNIX AND NOT APPLE)
    IF(UNIX)
	FIND_PROGRAM( CMAKE_CURL_CONFIG curl-config)
	MARK_AS_ADVANCED(CMAKE_CURL_CONFIG)

	IF(CMAKE_CURL_CONFIG)
	    IF(STATIC_CURL)
		# run the curl-config program to get --static-libs
		EXEC_PROGRAM(sh
			ARGS "${CMAKE_CURL_CONFIG} --static-libs"
			OUTPUT_VARIABLE CURL_STATIC_LIBS
			RETURN_VALUE RET)

		MESSAGE(STATUS "CURL RET = ${RET} libs: [${CURL_STATIC_LIBS}]")
	    ELSE()
		SET(RET 1)
	    ENDIF()

	    IF(RET EQUAL 0 AND CURL_STATIC_LIBS)
		MESSAGE(STATUS "#2 CURL RET = ${RET}, using CURL static libs")
		SET(CURL_LIBRARIES "-Bstatic ${CURL_STATIC_LIBS}")
	    ELSE()
		EXEC_PROGRAM(sh
		ARGS "${CMAKE_CURL_CONFIG} --libs"
		OUTPUT_VARIABLE CURL_DYNAMIC_LIBS
		RETURN_VALUE RET2)

		IF(RET2 EQUAL 0 AND CURL_DYNAMIC_LIBS)
		    MESSAGE(STATUS "#2 CURL RET = ${RET2}, using CURL dynamic libs: ${CURL_DYNAMIC_LIBS}")
		    SET(CURL_LIBRARIES "${CURL_DYNAMIC_LIBS}")
		ELSE()
		    MESSAGE(STATUS "#3 CURL RET = ${RET2}, using CURL libs found by cmake: ${CURL_LIBRARIES}")
		ENDIF()
	    ENDIF()
	ENDIF()
    ENDIF()
    IF(CURL_VERSION_STRING AND "${CURL_VERSION_STRING}" VERSION_LESS "${CURL_MIN_VERSION_MG}")
	MESSAGE(STATUS "(please visit http://curl.haxx.se/libcurl/ to find a newer version)")
	MESSAGE(FATAL_ERROR " CURL version = [${CURL_VERSION_STRING}] we require AT LEAST [7.16.4]")
    ENDIF()
ELSE()
    SET(CURL_LIBRARIES)
    SET(CURL_INCLUDE_DIRS)
ENDIF()
