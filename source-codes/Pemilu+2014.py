
# coding: utf-8

# In[1]:


get_ipython().run_line_magic('matplotlib', 'inline')

import numpy as np
import pandas as pd
import geopandas as gpd
from shapely.geometry import Point, Polygon

import folium

import matplotlib.pyplot as plt


# ## Loading Data Geo

# In[2]:


dapil = gpd.read_file("D:\\Portofolio Data Scientist\\pemilu-data\\dapil\\shapefiles\\dapil_nasional_DPR\\geojson\\DAPIL_NASIONAL_DPR.geojson")


# #### Lihat kolom dan isi

# In[3]:


dapil.columns


# In[4]:


dapil.head()


# #### Visualisasi data

# In[21]:


ax = dapil.plot(figsize=(20,20), cmap='tab20') #alpha = 0.5 (transparency)
#Possible values of cmap are: Accent, Accent_r, Blues, Blues_r, BrBG, BrBG_r, BuGn, BuGn_r, BuPu, BuPu_r, CMRmap, CMRmap_r, Dark2, Dark2_r, GnBu, GnBu_r, Greens, Greens_r, Greys, Greys_r, OrRd, OrRd_r, Oranges, Oranges_r, PRGn, PRGn_r, Paired, Paired_r, Pastel1, Pastel1_r, Pastel2, Pastel2_r, PiYG, PiYG_r, PuBu, PuBuGn, PuBuGn_r, PuBu_r, PuOr, PuOr_r, PuRd, PuRd_r, Purples, Purples_r, RdBu, RdBu_r, RdGy, RdGy_r, RdPu, RdPu_r, RdYlBu, RdYlBu_r, RdYlGn, RdYlGn_r, Reds, Reds_r, Set1, Set1_r, Set2, Set2_r, Set3, Set3_r, Spectral, Spectral_r, Wistia, Wistia_r, YlGn, YlGnBu, YlGnBu_r, YlGn_r, YlOrBr, YlOrBr_r, YlOrRd, YlOrRd_r, afmhot, afmhot_r, autumn, autumn_r, binary, binary_r, bone, bone_r, brg, brg_r, bwr, bwr_r, cividis, cividis_r, cool, cool_r, coolwarm, coolwarm_r, copper, copper_r, cubehelix, cubehelix_r, flag, flag_r, gist_earth, gist_earth_r, gist_gray, gist_gray_r, gist_heat, gist_heat_r, gist_ncar, gist_ncar_r, gist_rainbow, gist_rainbow_r, gist_stern, gist_stern_r, gist_yarg, gist_yarg_r, gnuplot, gnuplot2, gnuplot2_r, gnuplot_r, gray, gray_r, hot, hot_r, hsv, hsv_r, inferno, inferno_r, jet, jet_r, magma, magma_r, nipy_spectral, nipy_spectral_r, ocean, ocean_r, pink, pink_r, plasma, plasma_r, prism, prism_r, rainbow, rainbow_r, seismic, seismic_r, spring, spring_r, summer, summer_r, tab10, tab10_r, tab20, tab20_r, tab20b, tab20b_r, tab20c, tab20c_r, terrain, terrain_r, viridis, viridis_r, winter, winter_r


# # Loading data

# In[24]:


data = pd.read_csv(r'D:\Portofolio Data Scientist\pemilu-data\results\2014\calon_legaslatif\totals\dapil_vote_totals-dpr.csv')


# #### Lihat isi data

# In[25]:


data


# ### Merging data dan dapil

# In[4]:


data = data.merge(dapil, on = 'id_dapil')


# In[5]:


data


# #### Lihat tipe data hasil merging

# In[6]:


type(data)


# ## Membuat daftar partai

# In[73]:


partai = data[['id_partai', 'nama_partai']].drop_duplicates().sort_values(by = 'id_partai', ascending = True)
partai


# ## Membuat daftar provinsi

# In[75]:


provinsi = dapil[['id_provinsi', 'nm_provinsi']].drop_duplicates()
provinsi


# In[110]:


#gabungin semua atribut selain Shape_Leng & *_dapil --> ubah jadi no_dapil --> jadi gpd.DataFrame
provinsi_ = dapil[['Shape_Area', 'nm_provinsi', 'geometry']]#.dissolve(by = 'nm_provinsi')
type(provinsi_)


# In[111]:


provinsi_.dissolve(by = 'nm_provinsi', aggfunc = 'sum')


# In[108]:


provinsi_[0:47].dissolve(by = 'nm_provinsi', aggfunc = 'sum')


# ### Bermasalah
# Provinsi Kalsel (47:49) bermasalah

# In[105]:


provinsi_[49:50].dissolve(by = 'nm_provinsi', aggfunc = 'sum').reset_index()


# ### Bermasalah
# Provinsi Kaltim (50:51) bermasalah

# In[103]:


provinsi_[51:].dissolve(by = 'nm_provinsi', aggfunc = 'sum')


# ## Olah data menjadi summary

# In[124]:


pemenang2 = data[['nama_dapil', 'id_dapil', 'nama_partai', 'suara_calon_terpilih', 'suara_calon_semua', 'suara_partai', 'jumlah_suara']].groupby(['id_dapil', 'nama_dapil'])
stats2 = pemenang2.agg('sum').sort_values(by = 'jumlah_suara', ascending = False)
stats2


# In[119]:


stats2.reset_index()


# #### Lihat tipe data hasil olahan data

# In[13]:


type(stats2)


#  

# In[54]:


pemenang = data[['nama_dapil', 'nama_partai', 'suara_calon_terpilih', 'suara_calon_semua', 'suara_partai', 'jumlah_suara']].groupby(['nama_partai', 'nama_dapil'])


# In[55]:


stats = pemenang.agg('sum').sort_values(by='jumlah_suara', ascending=False)
stats


# In[56]:


stats = pemenang.agg('sum').sort_values(by='suara_partai', ascending=False)
stats


# In[57]:


stats.reset_index()


# 
# 

# In[60]:


pemenang_ = data[['nama_dapil', 'nama_partai', 'suara_calon_terpilih', 'suara_calon_semua', 'suara_partai', 'jumlah_suara']].groupby(['nama_dapil', 'nama_partai'])
stats_ = pemenang_.agg('sum')
stats_.reset_index()


# In[62]:


pemenang3 = data[['nama_dapil', 'nama_partai', 'suara_calon_terpilih', 'suara_calon_semua', 'suara_partai', 'jumlah_suara']].groupby(['nama_partai'])
stats3 = pemenang3.agg('sum').sort_values(by = 'jumlah_suara', ascending = False)
stats3


# ### Merging into geodata

# In[121]:


dapil_edit = dapil.merge(stats2.reset_index(), on = 'id_dapil')


# In[125]:


dapil_edit


# In[139]:


dapil_edit.plot(figsize=(36,9), column = 'jumlah_suara', legend = True)


# In[135]:


dapil_edit.plot(figsize=(24,6), column = 'suara_partai', legend = True)


# In[136]:


dapil_edit.plot(figsize=(24,6), column = 'suara_calon_semua', legend = True)


#  

# ## Per partai: NasDem

# In[148]:


nasdem = data.loc[data.id_partai == 1]
#nasdem = nasdem[['nama_dapil', 'id_dapil', 'suara_calon_terpilih', 'suara_calon_semua', 'suara_partai', 'jumlah_suara']].groupby(['id_dapil', 'nama_dapil']).agg('sum').sort_values(by = 'jumlah_suara', ascending = False)
nasdem


# In[149]:


dapil_nasdem = dapil.merge(nasdem, on = 'id_dapil')


# In[150]:


dapil_nasdem.plot(figsize=(36,9), column = 'jumlah_suara', legend = True)


# In[151]:


dapil_nasdem.plot(figsize=(36,9), column = 'suara_partai', legend = True)


# In[152]:


dapil_nasdem.plot(figsize=(36,9), column = 'suara_calon_terpilih', legend = True)


# ## Per partai: PDIP

# In[153]:


pdip = data.loc[data.id_partai == 4]
#pdip = pdip[['nama_dapil', 'id_dapil', 'suara_calon_terpilih', 'suara_calon_semua', 'suara_partai', 'jumlah_suara']].groupby(['id_dapil', 'nama_dapil']).agg('sum').sort_values(by = 'jumlah_suara', ascending = False)
pdip


# In[154]:


dapil_pdip = dapil.merge(pdip, on = 'id_dapil')


# In[155]:


dapil_pdip.plot(figsize=(36,9), column = 'jumlah_suara', legend = True)


# In[156]:


dapil_pdip.plot(figsize=(36,9), column = 'suara_partai', legend = True)


# In[157]:


dapil_pdip.plot(figsize=(36,9), column = 'suara_calon_terpilih', legend = True)


# In[158]:


dapil_pdip.plot(figsize=(36,9), column = 'suara_calon_semua', legend = True)


# ## Per partai: Golkar

# In[160]:


golkar = data.loc[data.id_partai == 5]
#golkar = golkar[['nama_dapil', 'id_dapil', 'suara_calon_terpilih', 'suara_calon_semua', 'suara_partai', 'jumlah_suara']].groupby(['id_dapil', 'nama_dapil']).agg('sum').sort_values(by = 'jumlah_suara', ascending = False)
golkar


# In[161]:


dapil_golkar = dapil.merge(golkar, on = 'id_dapil')


# In[163]:


dapil_golkar.plot(figsize=(36,9), column = 'jumlah_suara', legend = True)


# In[164]:


dapil_golkar.plot(figsize=(36,9), column = 'suara_partai', legend = True)


# In[165]:


dapil_golkar.plot(figsize=(36,9), column = 'suara_calon_terpilih', legend = True)


# In[166]:


dapil_golkar.plot(figsize=(36,9), column = 'suara_calon_semua', legend = True)


#  

# In[139]:


# Buat peta dengan jumlah_suara warna berdasarkan parpol pemenang di daerah tersebut, dan ketebalan berdasarkan proporsi pemenangan

dapil_edit.plot(figsize=(36,9), column = 'jumlah_suara', legend = True)

