#coding: utf-8

require 'prawn'

require File.expand_path(File.dirname(__FILE__) + "/report_helpers")
require File.expand_path(File.dirname(__FILE__) + "/report_info")

# This is the module for all classes in the prawn_report gem
module PrawnReport

  #Will be passed to pdf constructor, default page size is A4
  PAGE_SIZE = 'A4'
  DEFAULT_PAGE_LAYOUT = :portrait
  MARGIN = [20, 20, 20, 20] # [top, right, bottom, left]
  DEFAULT_REPORT_PARAMS = {:page_size => PAGE_SIZE, :margin => MARGIN,
    :page_layout => DEFAULT_PAGE_LAYOUT}
  
  LABEL_SIZE = 6
  TEXT_SIZE = 10
  
  SECTION_SPACING = LABEL_SIZE + 4
  
  LINE_WIDTH = 0.3
  
  DEFAULT_FONT = 'Times-Roman'
    
  TEXT_BOX_RADIUS = 2
  TEXT_BOX_HEIGTH = 20
  
  # Report is the base class for all reports, it encapsulates all logic for rendering
  #   report parts.
  class Report
    attr_reader :pdf, :data, :max_width, :max_height, :totals, :group_totals
    attr_accessor :header_class, :header_other_pages_class, :x, :params,
      :running_totals
    
    def initialize(report_params = {})
      @running_totals = report_params.delete(:running_totals) || []
      @num_pages = 1
      
      @params = DEFAULT_REPORT_PARAMS.merge(report_params)
      @pdf = Prawn::Document.new(@params)
        
      @pdf.font(DEFAULT_FONT)
      @pdf.line_width = LINE_WIDTH
      
      if @params[:page_layout] == :portrait
        w, h = *Prawn::Document::PageGeometry::SIZES[@params[:page_size]]
      else
        h, w = *Prawn::Document::PageGeometry::SIZES[@params[:page_size]]
      end
      @x = 0
      @y = @max_height = h - (@params[:margin][0] + @params[:margin][2])
      @max_width = w - (@params[:margin][1] + @params[:margin][3])

      @footer_size = 0
      @pdf.move_cursor_to(max_height - @params[:margin][2])
      
      @header_class = @header_other_pages_class = @summary_band_class =  @footer_class = nil
      @totals = {}
      @group_totals = {}
      
      initialize_running_totals
    end
    
    def draw(data)
      @data = data
      
      draw_header_first_page
      draw_internal
      draw_summary
      draw_footer
      
      second_pass
      
      @pdf.close_and_stroke
      @pdf.render
    end
    
    def new_page
      draw_footer
      
      @num_pages += 1
      @pdf.start_new_page
      @x = 0
      @pdf.move_down(@params[:margin][0])
      
      draw_header_other_pages
    end
    
    protected
    
    def draw_header_first_page
      draw_header(@header_class)
    end  
      
    def draw_header_other_pages
      draw_header(@header_other_pages_class || @header_class)
    end
    
    def draw_header(klass)
      if klass
        header = klass.new(self)
        header.draw
        @pdf.y = @max_height - header.height
        @x = 0
      end
    end
    
    def draw_footer
      if @footer_class
        footer = @footer_class.new(self)
        @pdf.move_cursor_to(@footer_class.height)
        footer.draw
      end
    end
    
    def draw_summary
      if @summary_class
        summary = @summary_class.new(self)
        summary.draw
      end
    end
    
    def draw_group_summary
      if @params[:group] && @params[:group][:summary_class]
        summary = @params[:group][:summary_class].new(self)
        summary.draw
      end
    end

    def draw_group_header
      if @params[:group][:header_class]
        header = @params[:group][:header_class].new(self)
        header.draw
      end
    end

    def second_pass
    
    end
    
    def run_totals(data_row)
      @running_totals.each do |rt|
        @totals[rt] = (@totals[rt] || 0) + data_row[rt]
        @group_totals[rt] = (@group_totals[rt] || 0) + data_row[rt]
      end
    end

    def initialize_running_totals
      @running_totals.each do |rt|
        @totals[rt] = 0
        @group_totals[rt] = 0
      end
    end

    def reset_group_totals
      @running_totals.each do |rt|
        @group_totals[rt] = 0
      end
    end
          
  end
end  

