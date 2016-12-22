function [im_out]=quant_naive(im_in,nb_levels)
interval=round( ( max(max(im_in))-min(min(im_in)) ) / nb_levels );
im_out=round(im_in/interval)*interval;
end