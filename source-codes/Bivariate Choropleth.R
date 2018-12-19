library(maps)
library(maptools)
library(sp)
library(lattice)
library(latticeExtra)
library(colorspace)
library(rgdal)
library(RColorBrewer)
library(rgeos)
library(classInt)
library(latticeExtra)
library(grid)
library(plyr)
library(raster)
library(dplyr)

# Loading Data Spasial
dapil <- rgdal::readOGR("D:/Portofolio Data Scientist/pemilu-data/dapil/shapefiles/dapil_nasional_DPR/geojson/DAPIL_NASIONAL_DPR.geojson", layer = "DAPIL_NASIONAL_DPR", stringsAsFactors = FALSE)
#dapil
str(dapil@data)

# Percobaan Plotting
#dapil$nm_provinsi <- as.factor(dapil$nm_provinsi)
#col.b <- colorRampPalette(brewer.pal(9,"Blues"))(33)
#spplot(dapil,"nm_provinsi", col.regions=col.b, main="Indonesia by Province", colorkey = TRUE, lwd=1, col="black",par.settings=list(panel.background=list(col="azure2")))

# Loading Data Atribut
data <- read.csv('D:/Portofolio Data Scientist/pemilu-data/results/2014/calon_legaslatif/totals/dapil_vote_totals-dpr.csv', stringsAsFactors = FALSE)
#summary(data)

# Sort data berdasarkan id_dapil
data <- data[with(data, order(id_dapil, peringkat_jumlah_suara)),]
rownames(data) <- 1:nrow(data)

# Penentuan nilai total
total <- data %>%
  group_by(id_dapil, nama_dapil) %>%
  #summarize(total_jumlah = sum(jumlah_suara), total_partai = sum(suara_partai), total_terpilih = sum(suara_calon_terpilih), total_semua = sum(suara_calon_semua)) %>% 
  #mutate(jumlah_suara = total_jumlah, suara_partai = total_partai, suara_calon_terpilih = total_terpilih, suara_calon_semua = total_semua)
  summarize(jumlah_suara = sum(jumlah_suara), suara_partai = sum(suara_partai), suara_calon_terpilih = sum(suara_calon_terpilih), suara_calon_semua = sum(suara_calon_semua))
  
# Filter berdasarkan pemenang jumlah suara di tiap dapil
pemenang_jumlah <- data[data$peringkat_jumlah_suara == 1,]
rownames(pemenang_jumlah) <- 1:nrow(pemenang_jumlah)

pemenang_partai <- data[data$peringkat_suara_partai == 1,]
rownames(pemenang_partai) <- 1:nrow(pemenang_partai)

pemenang_semua_calon <- data[data$peringkat_suara_calon_semua == 1,]
rownames(pemenang_semua_calon) <- 1:nrow(pemenang_semua_calon)

pemenang_terpilih <- data[data$peringkat_suara_calon_terpilih == 1,]
rownames(pemenang_terpilih) <- 1:nrow(pemenang_terpilih)


# Hitung persentase
pemenang_jumlah <- pemenang_jumlah %>% 
  mutate(pct_jumlah_suara = jumlah_suara/total$jumlah_suara * 100,
         pct_suara_partai = suara_partai/total$suara_partai * 100,
         pct_suara_calon_terpilih = suara_calon_terpilih/total$suara_calon_terpilih * 100,
         pct_suara_calon_semua = suara_calon_semua/total$suara_calon_semua * 100)

pemenang_partai <- pemenang_partai %>% 
  mutate(pct_jumlah_suara = jumlah_suara/total$jumlah_suara * 100,
         pct_suara_partai = suara_partai/total$suara_partai * 100,
         pct_suara_calon_terpilih = suara_calon_terpilih/total$suara_calon_terpilih * 100,
         pct_suara_calon_semua = suara_calon_semua/total$suara_calon_semua * 100)

pemenang_semua_calon <- pemenang_semua_calon %>% 
  mutate(pct_jumlah_suara = jumlah_suara/total$jumlah_suara * 100,
         pct_suara_partai = suara_partai/total$suara_partai * 100,
         pct_suara_calon_terpilih = suara_calon_terpilih/total$suara_calon_terpilih * 100,
         pct_suara_calon_semua = suara_calon_semua/total$suara_calon_semua * 100)

pemenang_terpilih <- pemenang_terpilih %>% 
  mutate(pct_jumlah_suara = jumlah_suara/total$jumlah_suara * 100,
         pct_suara_partai = suara_partai/total$suara_partai * 100,
         pct_suara_calon_terpilih = suara_calon_terpilih/total$suara_calon_terpilih * 100,
         pct_suara_calon_semua = suara_calon_semua/total$suara_calon_semua * 100)


# Pilihan kedua di setiap dapil
# Filter berdasarkan pemenang jumlah suara di tiap dapil
kedua_jumlah <- data[data$peringkat_jumlah_suara == 2,]
rownames(kedua_jumlah) <- 1:nrow(kedua_jumlah)

kedua_partai <- data[data$peringkat_suara_partai == 2,]
rownames(kedua_partai) <- 1:nrow(kedua_partai)

kedua_calon_semua <- data[data$peringkat_suara_calon_semua == 2,]
rownames(kedua_calon_semua) <- 1:nrow(kedua_calon_semua)

kedua_calon_terpilih <- data[data$peringkat_suara_calon_terpilih == 2,]
rownames(kedua_calon_terpilih) <- 1:nrow(kedua_calon_terpilih)

# Hitung persentase
kedua_jumlah <- kedua_jumlah %>% 
  mutate(pct_jumlah_suara = jumlah_suara/total$jumlah_suara * 100,
         pct_suara_partai = suara_partai/total$suara_partai * 100,
         pct_suara_calon_terpilih = suara_calon_terpilih/total$suara_calon_terpilih * 100,
         pct_suara_calon_semua = suara_calon_semua/total$suara_calon_semua * 100)

kedua_partai <- kedua_partai %>% 
  mutate(pct_jumlah_suara = jumlah_suara/total$jumlah_suara * 100,
         pct_suara_partai = suara_partai/total$suara_partai * 100,
         pct_suara_calon_terpilih = suara_calon_terpilih/total$suara_calon_terpilih * 100,
         pct_suara_calon_semua = suara_calon_semua/total$suara_calon_semua * 100)

kedua_calon_semua <- kedua_calon_semua %>% 
  mutate(pct_jumlah_suara = jumlah_suara/total$jumlah_suara * 100,
         pct_suara_partai = suara_partai/total$suara_partai * 100,
         pct_suara_calon_terpilih = suara_calon_terpilih/total$suara_calon_terpilih * 100,
         pct_suara_calon_semua = suara_calon_semua/total$suara_calon_semua * 100)

kedua_calon_terpilih <- kedua_calon_terpilih %>% 
  mutate(pct_jumlah_suara = jumlah_suara/total$jumlah_suara * 100,
         pct_suara_partai = suara_partai/total$suara_partai * 100,
         pct_suara_calon_terpilih = suara_calon_terpilih/total$suara_calon_terpilih * 100,
         pct_suara_calon_semua = suara_calon_semua/total$suara_calon_semua * 100)


# Perhitungan selisih kemenangan
# Hanya dibandingkan untuk kategori terkait, untuk menghindari nilai negatif (bisa jadi partai tersebut bukan yang peringkat pertama di kategori yang lain)
pemenang_jumlah <- pemenang_jumlah %>% 
  mutate(selisih_jumlah_suara = jumlah_suara - kedua_jumlah$jumlah_suara,
         pct_selisih_jumlah_suara = selisih_jumlah_suara/total$jumlah_suara * 100)

pemenang_partai <- pemenang_partai %>% 
  mutate(selisih_suara_partai = suara_partai - kedua_partai$suara_partai,
         pct_selisih_suara_partai = selisih_suara_partai/total$suara_partai * 100)

pemenang_terpilih <- pemenang_terpilih %>% 
  mutate(selisih_suara_calon_terpilih = suara_calon_terpilih - kedua_partai$suara_calon_terpilih,
         pct_selisih_suara_calon_terpilih = selisih_suara_calon_terpilih/total$suara_calon_terpilih * 100)

pemenang_semua_calon <- pemenang_semua_calon %>% 
  mutate(selisih_suara_calon_semua = suara_calon_semua - kedua_partai$suara_calon_semua,
         pct_selisih_suara_calon_semua = selisih_suara_calon_semua/total$suara_calon_semua * 100)


# Buat daftar partai yang memenangkan jumlah suara
pemenang_jumlah %>% 
  group_by(id_partai, nama_partai) %>% 
  summarize(jumlah = n(), suara_maksimal = max(jumlah_suara), suara_minimal = min(jumlah_suara), proporsi_maksimal = max(pct_jumlah_suara), proporsi_minimal = min(pct_jumlah_suara)) %>% 
  arrange(desc(jumlah))
## Total ada 8 partai yang memenangi dapil menurut jumlah suara dalam pemilu tahun 2014

pemenang_terpilih %>% 
  group_by(id_partai, nama_partai) %>% 
  summarize(jumlah = n(), suara_maksimal = max(jumlah_suara), suara_minimal = min(jumlah_suara), proporsi_maksimal = max(pct_jumlah_suara), proporsi_minimal = min(pct_jumlah_suara)) %>% 
  arrange(desc(jumlah))
## Total ada 9 partai yang memenangi dapil menurut jumlah suara dalam pemilu tahun 2014


# Penyusunan warna kategorikal (partai)
classes <- levels(factor(pemenang_jumlah$nama_partai)) #Perlu ditambahkan factor(...) supaya memperbaharui levels dari ...$nama_partai
nClasses <- length(classes)
qualPal <- rainbow_hcl(nClasses, start=30, end=300)
step <- 360/nClasses
hue = (30 + step*(seq_len(nClasses)-1))%%360
qualPal <- hcl(hue, c=50, l=70)

#Warna
#PAN: #0F2686
##PBB: hijau terang::#6CE51E
#PDI-P: #DA251C
#Demokrat: biru tua::#27488F (perlu lebih muda), biru muda::#A3D0EF
#Gerindra: kuning::#FCCF00 (kurang jingga), abu-abu::#646464
#Golkar: #FFF200
##Hanura: jingga kecoklatan::#EFA647
##PKPI: merah muda::#F16357
##PKS: hitam terang::#1F1A17
#PKB: #00923F
#NasDem: biru::#31328C, jingga::#F0841F
#PPP: #096309 (perlu lebih gelap), #0E5E39
warna_parpol_jumlah <- c("#0F2686", "#DA251C", "#A3D0EF", "#646464", "#FFF200", "#00923F", "#F0841F", "#0E5E39")
h_parpol_jumlah <- c(228.4, 2.84, 204.47, 0, 56.94, 145.89, 29, 152.25)
step_h_parpol_jumlah <- h_parpol_jumlah/8
l_parpol_jumlah <- c(29.22, 48.24, 78.82, 39.22, 50, 28.63, 53.14, 21.18)

warna_parpol_terpilih <- c("#0F2686", "#DA251C", "#A3D0EF", "#646464", "#FFF200", "#1F1A17", "#00923F", "#F0841F", "#0E5E39")


# Merge into dapil_pemenang
dapil_pemenang_jumlah <- sp::merge(dapil, pemenang_jumlah, by.x="id_dapil", by.y="id_dapil")
dapil_pemenang_jumlah$nama_partai <- as.factor(dapil_pemenang_jumlah$nama_partai)

spplot(dapil_pemenang_jumlah["nama_partai"], col.regions=warna_parpol_jumlah, main="Partai Pemenang di Masing-masing Dapil pada Pemilu 2014", lwd=1, col="black", par.settings=list(panel.background=list(col="azure2")))

# Untuk variabel kuantitatif
quantPal <- rev(heat_hcl(16))
spplot(dapil_pemenang_jumlah["pct_jumlah_suara"], col="transparent", col.regions=quantPal, par.settings=list(panel.background=list(col="azure2")))


#Now we want to put these two together somehow.
multiPal <- lapply(1:nClasses, function(i){rev(sequential_hcl(16, h = h_parpol_jumlah[i], l=l_parpol_jumlah[i]))})
extent(dapil_pemenang_jumlah)

pList <- lapply(1:nClasses, function(i){
  mapClass <- dapil_pemenang_jumlah[dapil_pemenang_jumlah$nama_partai==classes[i],]
  pClass <- spplot(mapClass["pct_jumlah_suara"],xlim=c(95.00971,141.0194),ylim=c(-11.00762,6.07694), par.settings=list(panel.background=list(col="azure2")), col.regions=multiPal[[i]], col="black", colorkey=(if(i==nClasses) TRUE else list(labels=rep("",9))), at = seq(10, 50, by=5))
  })
p <- Reduce('+',pList)

#In order to make a sensible legend, we are going to want to make a legend for each element of pList (ie; a different legend for each of the regions of Japan).
addTitle <- function(legend, title){
  titleGrob <- textGrob(title, gp=gpar(fontsize=8), hjust=1, vjust=1)
  legendGrob <- eval(as.call(c(as.symbol(legend$fun), legend$args)))
  ly <- grid.layout(ncol=1, nrow=2,
                    widths=unit(0.9,"grobwidth", data=legendGrob))
  fg <- frameGrob(ly, name=paste("legendTitle", title, sep="_"))
  pg <- packGrob(fg, titleGrob, row=2)
  pg <- packGrob(pg, legendGrob, row=1)
}

for (i in seq_along(classes)){
  lg <- pList[[i]]$legend$right
  pList[[i]]$legend$right <- list(fun="addTitle",args=list(legend=lg, title=classes[i]))
}

#Now we want to use the p trellis object to merge the legends from the components of pList (the individual polygon data for each region of Japan).
legendList <- lapply(pList, function(x){
  lg <- x$legend$right
  clKey <- eval(as.call(c(as.symbol(lg$fun), lg$args)))
  clKey
})

#now that we have all the legends merged, we need to put them into a unique object in order to be ready to plot.
packLegend <- function(legendList){
  N <- length(legendList)
  ly <- grid.layout(nrow = 1, ncol = N)
  g <- frameGrob(layout = ly, name = "mergedLegend")
  for (i in 1:N) g <- packGrob(g, legendList[[i]], col = i)
  g
}

#Final step to create the legend:p will include all the legends
p$legend$right<-list(fun ="packLegend",args=list(legendList=legendList))
#now we can finally plot the multivariate chloropleth map
J.Lines<-dapil_pemenang_jumlah

p+
  layer(sp.polygons(J.Lines,lwd=0.5))


# Ganti Parameter: suara calon terpilih
dapil_pemenang_suara_calon_terpilih <- sp::merge(dapil, pemenang_terpilih, by.x="id_dapil", by.y="id_dapil")
dapil_pemenang_suara_calon_terpilih$nama_partai <- as.factor(dapil_pemenang_suara_calon_terpilih$nama_partai)

spplot(dapil_pemenang_suara_calon_terpilih["nama_partai"], col.regions=warna_parpol_terpilih, main="Partai dengan Caleg Terpilih Bersuara Terbanyak Menurut Dapil pada Pemilu 2014", lwd=1, col="black", par.settings=list(panel.background=list(col="azure2")))
