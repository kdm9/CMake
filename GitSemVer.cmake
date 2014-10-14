INCLUDE(GetGitRevisionDescription)

function(GetGitSemVer _var)
	get_git_head_revision(rev hash)
	git_get_exact_tag(tag)

	IF(NOT "${tag}" MATCHES "^-")
		SET(vers "${tag}")
	ELSE()
		git_describe(gitdesc "--always")
		if("${gitdesc}" MATCHES "^.+-.+-.+$")
			STRING (REGEX REPLACE "-" " " gdlist ${gitdesc})
			SEPARATE_ARGUMENTS(gdlist)
			LIST(GET gdlist 0 tag)
			LIST(GET gdlist 1 cmts_since_tag)
			SET(vers "${tag}-${cmts_since_tag}-dirty")
		ELSE()
			SET(vers "dirty")
		ENDIF()
	ENDIF()

	IF (NOT "${hash}" STREQUAL "")
		STRING(SUBSTRING ${hash} 0 7 hash)
		set(vers "${vers}+git=${hash}")
	ENDIF()
	set(${_var} ${vers} PARENT_SCOPE)
endfunction()
