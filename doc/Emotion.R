# Don't run, or it will take about 6-8 hours
endNotations <- c("?", ".", ",","!", "|", ":", "\n", "\r\n")
sample<-lyrics%>%filter(genre=="Folk"|genre=="Rock"|genre=="Pop")
lyrics.list<-tibble(text=sample$lyrics)
data.df<-NULL
for(i in 1:nrow(lyrics.list)){
  sentences<-sent_detect(lyrics.list$text[[i]],
                        endmarks = endNotations)
  if(length(sentences)>0){
    emotions=matrix(emotion(sentences)$emotion, 
                    nrow=length(sentences), 
                    byrow=T)
    colnames(emotions)=emotion(sentences[1])$emotion_type
    emotions=data.frame(emotions)
    emotions=select(emotions,
                  anticipation,
                   joy, 
                   surprise, 
                   trust, 
                   anger, 
                   disgust, 
                   fear, 
                   sadness)
    word.count<-word_count(sentences)
    data.df=rbind(data.df, 
                        cbind(sample[i,-ncol(lyrics)],
                              sentences=as.character(sentences), 
                              word.count,
                              emotions,
                              sent.id=1:length(sentences)
                              )
    )
  }
}