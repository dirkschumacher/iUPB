@iUPB.Navigator = {}
@iUPB.Navigator.vars = {}
@iUPB.Navigator.TRUNCATE_LENGTH = 23
@iUPB.Navigator.FACULTIES_URL = "http://navigator.api.i-upb.de/faculties.jsonp?callback=?"
@iUPB.Navigator.INFOS_URL = "http://navigator.api.i-upb.de/faculties/#FID/studies/#SID/infos.jsonp?callback=?"

@iUPB.Navigator.infosURL = (faculty_id, study_id) ->
	window.iUPB.Navigator.INFOS_URL.replace("#FID", faculty_id).replace("#SID", study_id)

@iUPB.Navigator.loadStudyData = (callback = null) ->
	jQuery.getJSON window.iUPB.Navigator.FACULTIES_URL, (data) ->
		window.iUPB.Navigator.vars.studies = data
		if callback
			callback()
		
	
@iUPB.Navigator.getStudy = (faculty_id, study_id) ->
	result = {}
	jQuery.each window.iUPB.Navigator.getStudiesForFaculty(faculty_id), (index, study) ->
		if study.id.toString() == study_id.toString()
			result = study
	result

@iUPB.Navigator.getStudiesForFaculty = (faculty_id) ->
	result = []
	jQuery.each window.iUPB.Navigator.vars.studies, (index, faculty) ->
		if faculty.id.toString() == faculty_id.toString()
			result = faculty.studies
	result

@iUPB.Navigator.selectFaculty = (div, id) ->
	items = jQuery.map window.iUPB.Navigator.getStudiesForFaculty(id), (study) ->
		'<p class="well bold" id="study_' + study.id + '"><a class="hand" data-faculty-id= "' + id + '" data-choose-study="' + study.id + '">' + study.name + '</a></p>'
	jQuery(div).html jQuery('<div/>', { html: items.join('') })
	jQuery("#chooser_header").html window.iUPB.Navigator.vars.second_header

@iUPB.Navigator.selectStudy = (div, id, faculty_id) ->
	jQuery.cookie 'iupb_study', {"study_id": id, "faculty_id": faculty_id}, { expires: 182, path: '/' }
	jQuery.getJSON window.iUPB.Navigator.infosURL(faculty_id, id), (data) ->
		items = jQuery.map data, (info) ->
			'<div class=" bold well" id="info_' + info.id + '"><h4>' + 
				info.role_text + '</h4><p>' + 	(if info.link then ('<a class="external-confirm" href="' + info.link + '">' + info.name +  '</a>') else info.name) + '<a href="#" class="huge pull-right"><i class="icon-arrow-right"></i></a>' + 
				(if info.link then ('<br><em><a href="' + info.mail + '">' + '<i class="icon-envelope"></i> Mail</a></em>') else '') + '</p></div>'
		jQuery("#intro_text").hide()
		jQuery(div).html jQuery('<div/>', { html: items.join('') })
		jQuery("#chooser_header").html window.iUPB.Navigator.vars.back_icon + " " + window.iUPB.Navigator.getStudy(faculty_id, id).name

@iUPB.Navigator.setupStudyChooser = (div) ->
	jQuery(document).on "click", "a[data-choose-faculty]", () ->
		window.iUPB.Navigator.selectFaculty div, jQuery(this).attr("data-choose-faculty")
	jQuery(document).on "click", "a[data-choose-study]", () ->
		window.iUPB.Navigator.selectStudy div, jQuery(this).attr("data-choose-study"), jQuery(this).attr("data-faculty-id")

@iUPB.Navigator.setupFacultyChooser = (div) ->
		if window.iUPB.Navigator.vars.studies
			items = jQuery.map window.iUPB.Navigator.vars.studies, (faculty) ->
				'<p class="well bold" id="faculty_' + faculty.id + '"><a class="hand" data-choose-faculty="' + faculty.id + '">' + faculty.name + '</a></p>'
			jQuery(div).html jQuery('<div/>', { html: items.join('') })
			iUPB.Navigator.setupStudyChooser(div)
			jQuery('#wait-message').hide()
		else
			window.iUPB.Navigator.loadStudyData () -> 
			  window.iUPB.Navigator.setupFacultyChooser(div)
		
	
