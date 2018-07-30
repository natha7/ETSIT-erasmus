
module PdfHelper
    def create_pdf(user)
        Prawn::Document.new(:page_size => 'A4') do

        	steps = user.student_application_form
            require 'active_support'


        	# Blue box with logo
        	def header
        		fill_color "FFFFFF"
        		rectangle [-40, 810], 632, 60
        		fill
            image Rails.root.join("app/assets/images/logoescuela.jpg"), :width => 130, :at => [400, 790]
        		image Rails.root.join("app/assets/images/logoUPM.jpg"), :width => 50, :at => [-10, 790]
            fill_color "4664A2"
            move_down 56
            text "UNIVERSIDAD POLITÉCNICA DE MADRID" , :align => :center, :size => 12
            text "ESCUELA TÉCNICA SUPERIOR DE INGENIEROS DE TELECOMUNICACIÓN" , :align => :center, :size => 12

        		fill_color "4664A2"
        	end

        	# Section title
        	def title(field, size = 18)
        		move_down 20
        		fill_color "4664A2"
        		text ("<b>#{field}</b>"), :inline_format => true, :align => :center,:size => size
        		move_down 5
        		fill_color "000000"
        	end
          def section(field, size = 13)
            move_down 10
            fill_color "4664A2"
            text ("<b>#{field}</b>"), :inline_format => true, :size => size
            move_down 5
            fill_color "000000"
          end
        	# Subtitle (user name)
        	def subtitle(name)
        		fill_color "777777"
        		text ("<b>#{name}</b>"), :inline_format => true, :align => :center,:size => 16
        		fill_color "000000"
            move_down 20
        	end

        	# Form field label
        	def label(field)
        		fill_color "000000"
    			  text ("<b>#{field}</b>"), :inline_format => true
    			  fill_color "000000"
    			  move_down 4
    		end	

    		# Form field value
        	def check_field(field, period=true)
        		fill_color "4664A2"
    			  text (field.blank? ? "<em>Empty</em>" : field), :inline_format => true
        		fill_color "000000"
        		move_down 10 if period
    		end

            def checkbox(label, flag, x_position = 0, y_position = cursor  )
               line_width(1)
               draw_text label , :at => [x_position + 16 , y_position-10], :size => 9
               bounding_box([x_position, y_position], width: 12, height: 12) do
                stroke_bounds
                text("x", align: :center, valign: :top) if flag
              end
            end

          # Form plain text
          def plain_text(field)
            fill_color "000000"
            text ("#{field}"), :inline_format => true, :size => 9, :leading => 5
            fill_color "000000"
            move_down 2
          end
          # Use Source Sans Pro Font
    		font_families.update(
    		 "SourceSansPro" => {
    		 	:normal => Rails.root.join("app/assets/fonts/SourceSansPro.ttf"),
    		 	:bold => Rails.root.join("app/assets/fonts/SourceSansPro-Bold.ttf"),
    		 	:italic => Rails.root.join("app/assets/fonts/SourceSansPro-Italic.ttf")
    		 }
    		)
    		#font "SourceSansPro"
        font "Helvetica"

    		# Add header to all pages
    		repeat(:all) do
    		  header
    		end

    		# Add page number to all pages
    		repeat(:all, :dynamic => true) do
    		 draw_text page_number, :at => [530, -10], :size => 9
             draw_text "ETSIT-UPM Application form", :at => [-10,-13], :size => 9
    		end

    		# Cover
    		title("Student Application Form", 20)
    		subtitle(user.first_name + " " + user.family_name)

        # Step 3
        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke
        section("Study year")
        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke

        move_down 10
        label("Academic year")
        check_field(steps.academic_year)
        label("Programme")
        check_field(steps.programme)
        label("Field of study")
        check_field(steps.field_of_study)

        # Personal data
        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke
        section("Student data")
        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke

        move_down 10
        label("Name")
        check_field(user.first_name)
        label("Last Name")
        check_field(user.family_name)
        label("Date of birth")
        day = user.birth_date.blank? ? "" : user.birth_date.strftime("%b, #{user.birth_date.day.ordinalize} %Y")
        check_field(day)
        label("Place of birth")
        check_field(user.born_place)
        label("Gender")
        check_field(user.sex)
        label("Address")
        check_field(user.permanent_adress)
        label("Nationality")
        check_field(user.nationality)
        label("Phone number")
        check_field(user.phone_number)
        label("E-mail")
        check_field(user.email)

        start_new_page


        # Step 1
        move_down 100
        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke
        section("Sending Institution")
        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke

        move_down 10
        label("Name")
        check_field(steps.inst_sending_name)
        label("Erasmus Code")
        check_field(steps.erasmus_code)
        label("Dept. Coordinator")
        check_field(steps.dept_coordinator)
        label("School Family Dept")
        check_field(steps.school_family_dpt)
        label("Institution Address")
        check_field(steps.inst_adress)
        label("Contact person")
        check_field(steps.contact_person)
        label("Institution phone")
        check_field(steps.inst_telephone)
        label("Institution e-mail")
        check_field(steps.inst_email)

        # Step 2
        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke
        section("Purpose of stay")
        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke

        move_down 10
        label("Project work")
        check_field(steps.project_work)
        label("Under Graduate Courses")
        check_field(steps.under_grad_courses)
        label("Graduate Courses")
        check_field(steps.graduate_courses)

        start_new_page

        # Step 4
        move_down 100

        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke
        section("Language Competence")
        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke

        move_down 10
        label("Mother Tongue")
        check_field(steps.mother_tongue)
        label("Language Instruction")
        check_field(steps.language_instruction)
        label("Other languages")
        if !steps.languages.blank?
            move_down 5
            steps.languages.each do |lang|
                check_field("  " +lang.name  )
                move_down -5
                indent(10) do
                    checkbox("Currently Studying" , lang.currently_studying, 0, cursor )
                    checkbox("Able to follow lectures" , lang.able_follow_lectures, 100, cursor + 12 )
                    checkbox("Able to follow lectures with extra preparation" , lang.able_follow_lectures_extra_preparation, 210, cursor + 12 )
                end
                move_down 8
            end
        else
            check_field("No other languages")
        end


        # Step 5

        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke
        section("Work Experience related to current study")
        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke

        move_down 10

        if !steps.work_experiences.blank?
            move_down 5
            steps.work_experiences.each do |work|
                label("Position")
                check_field work.firm_organisation
                label("Organisation")
                check_field work.firm_organisation
                label("From")
                day = work.from.blank? ? "" : work.from.strftime("%b, #{work.from.day.ordinalize} %Y")
                check_field(day)
                label("To")
                day = work.to.blank? ? "" : work.to.strftime("%b, #{work.to.day.ordinalize} %Y")
                check_field(day)
                label("Country")
                check_field work.country
                # checkbox("Currently Studying" , lang.currently_studying, 0, cursor )
                # checkbox("Able to follow lectures" , lang.able_follow_lectures, 100, cursor + 12 )
                # checkbox("Able to follow lectures with extra preparation" , lang.able_follow_lectures_extra_preparation, 210, cursor + 12 )
                line_width(1)
                stroke_color "999999"
                horizontal_line(bounds.left, bounds.right-10)
                move_down 6
                stroke
            end
        else
            check_field("No work experience")
        end

        start_new_page

        # Step 6
        move_down 100

        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke
        section("Previous and current studies")
        line_width(1)
        stroke_color "4664A2"
        horizontal_line(bounds.left, bounds.right-10)
        stroke

        move_down 10
        label("Current Diploma Degree")
        check_field(steps.current_diploma_degree)
        label("Year Attended")
        check_field(steps.year_attended)
        label("Specialization Area")
        check_field(steps.specialization_area)
        label("Already Study Abroad")
        check_field(steps.already_study_abroad ? "Yes" : "No")
        label("Where Study Abroad")
        check_field(steps.where_study_abroad)
        label("Where Institution Abroad")
        check_field(steps.where_institution_abroad)

        # Final text
        move_down 10
          line_width(1)
          stroke_color "999999"
          horizontal_line(bounds.left, bounds.right-10)
          stroke
          move_down 20
          plain_text("Other documents to send along with this form: Curriculum Vitae, Motivation letter, Official Transcript of Records, Valid Insurance Policy, Copy of national identity card or passport, Two additional Photographs")
          plain_text("Additional documentation for degree-seeking students: Two recommendation letters, Official GPA, English Test Score (B2)")
          plain_text("I hereby give my consent to send this form along with a copy of my Transcript of Records and a letter of presentation to host institution, and I declare that all the information given is correct and complete.")
          move_down 40
          draw_text "Applicant's signature", :at => [30, 30], :size => 9
          draw_text "Place and date:", :at => [200, 30], :size => 9
          #text ("Applicant's signature"), :inline_format => true, :size => 9, :leading => 5, :at => [400, 790]


        end.render 
    end
end